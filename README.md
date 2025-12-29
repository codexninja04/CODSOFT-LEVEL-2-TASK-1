# Job Board Platform

A full-stack job board application built with React, TypeScript, TailwindCSS, and Supabase. This platform allows employers to post job listings and manage applications, while candidates can browse jobs, apply, and track their applications.

## Features

### For Employers
- Post new job listings with detailed information
- Manage job postings (activate/deactivate, delete)
- View and manage applications
- Update application status (pending, reviewed, accepted, rejected)
- Dashboard to track all posted jobs and applications

### For Candidates
- Browse and search job listings by keyword, location, and category
- Apply to jobs with resume and cover letter
- Upload and manage resume
- Track application status
- Personal dashboard for managing profile and applications

### General Features
- User authentication with role-based access (Employer/Candidate)
- Beautiful, modern UI with blue gradient design
- Responsive design for all screen sizes
- Search and filter functionality
- Real-time data updates
- Secure file upload for resumes

## Tech Stack

### Frontend
- React 18
- TypeScript
- TailwindCSS
- React Router DOM
- Lucide React (icons)
- Vite (build tool)

### Backend
- Supabase (PostgreSQL database)
- Supabase Auth (authentication)
- Supabase Storage (file uploads)

## Getting Started

### Prerequisites
- Node.js (v16 or higher)
- npm or yarn
- A Supabase account

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd job-board
```

2. Install dependencies:
```bash
npm install
```

3. Set up Supabase:
   - Go to [Supabase](https://supabase.com) and create a new project
   - Wait for the database to be provisioned
   - Copy your project URL and anon key

4. Configure environment variables:
   - Open the `.env` file in the root directory
   - Replace the placeholder values with your Supabase credentials:
```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

5. Set up Supabase Storage:
   - Go to your Supabase project dashboard
   - Navigate to Storage section
   - Create a new bucket named `resumes`
   - Set the bucket to public (or configure appropriate policies)

6. Database is already set up with migrations. The schema includes:
   - `profiles` table for user data
   - `jobs` table for job listings
   - `applications` table for job applications
   - Row Level Security (RLS) policies for data protection

### Running the Application

Development mode:
```bash
npm run dev
```

The application will be available at `http://localhost:5173`

Build for production:
```bash
npm run build
```

Preview production build:
```bash
npm run preview
```

## Usage Guide

### For Employers

1. Sign up with an "Hire Talent" account
2. After login, click "Post a Job" in the navigation
3. Fill in the job details and submit
4. Access your dashboard to manage jobs and applications
5. View applicants and update their application status

### For Candidates

1. Sign up with a "Find a Job" account
2. Browse available jobs on the home page or jobs page
3. Use search filters to find relevant positions
4. Upload your resume in the dashboard
5. Click on a job to view details and apply
6. Track your applications in your dashboard

## Project Structure

```
job-board/
├── src/
│   ├── components/          # Reusable components
│   │   ├── Hero.tsx        # Hero section with search
│   │   └── Navbar.tsx      # Navigation bar
│   ├── contexts/           # React contexts
│   │   └── AuthContext.tsx # Authentication context
│   ├── lib/                # Utilities and configs
│   │   └── supabase.ts     # Supabase client setup
│   ├── pages/              # Page components
│   │   ├── Home.tsx
│   │   ├── Jobs.tsx
│   │   ├── JobDetails.tsx
│   │   ├── Login.tsx
│   │   ├── Signup.tsx
│   │   ├── Contact.tsx
│   │   ├── EmployerDashboard.tsx
│   │   ├── CandidateDashboard.tsx
│   │   └── PostJob.tsx
│   ├── App.tsx             # Main app component with routing
│   ├── main.tsx            # Application entry point
│   └── index.css           # Global styles
├── .env                    # Environment variables
├── package.json
├── tailwind.config.js
├── tsconfig.json
└── vite.config.ts
```

## Database Schema

### profiles
- User profile information
- Extends Supabase auth.users
- Role-based (employer/candidate)

### jobs
- Job listings with full details
- Linked to employer profiles
- Active/inactive status

### applications
- Job applications from candidates
- Includes resume and cover letter
- Status tracking (pending, reviewed, accepted, rejected)

## Security

- Row Level Security (RLS) enabled on all tables
- Users can only access their own data
- Employers can only manage their own jobs
- Candidates can only apply once per job
- Secure authentication with Supabase Auth

## Deployment

### Frontend (Netlify)

1. Connect your repository to Netlify
2. Set build command: `npm run build`
3. Set publish directory: `dist`
4. Add environment variables in Netlify dashboard
5. Deploy

### Backend (Supabase)

The backend is already hosted on Supabase. No additional deployment needed.

## Support

For issues or questions, please contact support through the Contact page or open an issue on GitHub.

## License

MIT License
