/*
  # Job Board Database Schema

  1. New Tables
    - `profiles`
      - `id` (uuid, primary key, references auth.users)
      - `email` (text)
      - `full_name` (text)
      - `role` (text: 'employer' or 'candidate')
      - `company_name` (text, nullable - for employers)
      - `resume_url` (text, nullable - for candidates)
      - `phone` (text, nullable)
      - `location` (text, nullable)
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)
    
    - `jobs`
      - `id` (uuid, primary key)
      - `employer_id` (uuid, references profiles)
      - `title` (text)
      - `company` (text)
      - `location` (text)
      - `category` (text)
      - `job_type` (text: 'full-time', 'part-time', 'contract', 'freelance')
      - `salary_min` (integer, nullable)
      - `salary_max` (integer, nullable)
      - `description` (text)
      - `requirements` (text)
      - `is_active` (boolean)
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)
    
    - `applications`
      - `id` (uuid, primary key)
      - `job_id` (uuid, references jobs)
      - `candidate_id` (uuid, references profiles)
      - `resume_url` (text)
      - `cover_letter` (text, nullable)
      - `status` (text: 'pending', 'reviewed', 'accepted', 'rejected')
      - `created_at` (timestamptz)

  2. Security
    - Enable RLS on all tables
    - Profiles: Users can read all profiles, but only update their own
    - Jobs: Anyone can read active jobs, only employers can create/update/delete their own jobs
    - Applications: Candidates can create and view their own applications, employers can view applications for their jobs
*/

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  email text NOT NULL,
  full_name text NOT NULL,
  role text NOT NULL CHECK (role IN ('employer', 'candidate')),
  company_name text,
  resume_url text,
  phone text,
  location text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view profiles"
  ON profiles FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Create jobs table
CREATE TABLE IF NOT EXISTS jobs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  employer_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title text NOT NULL,
  company text NOT NULL,
  location text NOT NULL,
  category text NOT NULL,
  job_type text NOT NULL CHECK (job_type IN ('full-time', 'part-time', 'contract', 'freelance')),
  salary_min integer,
  salary_max integer,
  description text NOT NULL,
  requirements text NOT NULL,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view active jobs"
  ON jobs FOR SELECT
  TO authenticated
  USING (is_active = true);

CREATE POLICY "Employers can view their own jobs"
  ON jobs FOR SELECT
  TO authenticated
  USING (employer_id = auth.uid());

CREATE POLICY "Employers can create jobs"
  ON jobs FOR INSERT
  TO authenticated
  WITH CHECK (employer_id = auth.uid());

CREATE POLICY "Employers can update own jobs"
  ON jobs FOR UPDATE
  TO authenticated
  USING (employer_id = auth.uid())
  WITH CHECK (employer_id = auth.uid());

CREATE POLICY "Employers can delete own jobs"
  ON jobs FOR DELETE
  TO authenticated
  USING (employer_id = auth.uid());

-- Create applications table
CREATE TABLE IF NOT EXISTS applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id uuid NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  candidate_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  resume_url text NOT NULL,
  cover_letter text,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'accepted', 'rejected')),
  created_at timestamptz DEFAULT now(),
  UNIQUE(job_id, candidate_id)
);

ALTER TABLE applications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Candidates can view own applications"
  ON applications FOR SELECT
  TO authenticated
  USING (candidate_id = auth.uid());

CREATE POLICY "Employers can view applications for their jobs"
  ON applications FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM jobs
      WHERE jobs.id = applications.job_id
      AND jobs.employer_id = auth.uid()
    )
  );

CREATE POLICY "Candidates can create applications"
  ON applications FOR INSERT
  TO authenticated
  WITH CHECK (candidate_id = auth.uid());

CREATE POLICY "Employers can update application status"
  ON applications FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM jobs
      WHERE jobs.id = applications.job_id
      AND jobs.employer_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM jobs
      WHERE jobs.id = applications.job_id
      AND jobs.employer_id = auth.uid()
    )
  );

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_jobs_employer_id ON jobs(employer_id);
CREATE INDEX IF NOT EXISTS idx_jobs_category ON jobs(category);
CREATE INDEX IF NOT EXISTS idx_jobs_location ON jobs(location);
CREATE INDEX IF NOT EXISTS idx_applications_job_id ON applications(job_id);
CREATE INDEX IF NOT EXISTS idx_applications_candidate_id ON applications(candidate_id);