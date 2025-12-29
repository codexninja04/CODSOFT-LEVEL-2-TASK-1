# Setup Instructions

## Supabase Setup Guide

### Step 1: Create a Supabase Project

1. Go to [Supabase](https://supabase.com)
2. Sign in or create an account
3. Click "New Project"
4. Fill in your project details:
   - Project Name: Choose a name for your job board
   - Database Password: Create a strong password
   - Region: Select the closest region to your users
5. Click "Create new project" and wait for provisioning (2-3 minutes)

### Step 2: Get Your API Credentials

1. In your Supabase project dashboard, click on "Settings" (gear icon)
2. Navigate to "API" section
3. Copy the following credentials:
   - Project URL (under "Project URL")
   - Anon/Public key (under "Project API keys")

### Step 3: Configure Environment Variables

1. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

2. Open `.env` and replace the placeholder values:
```env
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

### Step 4: Database Setup

The database schema has already been applied through migrations. Your database should include:
- `profiles` table
- `jobs` table
- `applications` table
- All necessary RLS policies

You can verify this by going to:
1. Table Editor in Supabase dashboard
2. You should see the three tables listed

### Step 5: Set Up Storage for Resumes

1. In your Supabase dashboard, navigate to "Storage"
2. Click "Create a new bucket"
3. Name it exactly: `resumes`
4. Set it to **Public bucket** (check the box)
5. Click "Create bucket"

#### Configure Storage Policies

After creating the bucket, set up policies:

1. Click on the `resumes` bucket
2. Go to "Policies" tab
3. Add the following policies:

**Policy 1: Allow authenticated users to upload**
- Policy name: `Authenticated users can upload resumes`
- Allowed operation: INSERT
- Policy definition:
```sql
(bucket_id = 'resumes'::text) AND (auth.role() = 'authenticated'::text)
```

**Policy 2: Allow public read access**
- Policy name: `Public can view resumes`
- Allowed operation: SELECT
- Policy definition:
```sql
(bucket_id = 'resumes'::text)
```

### Step 6: Authentication Setup

Supabase Auth is already configured. Default settings are:
- Email/Password authentication enabled
- Email confirmation: Disabled (for easier testing)
- Users can sign up

You can adjust these settings in:
1. Authentication → Settings
2. Configure email templates and other options as needed

### Step 7: Install Dependencies and Run

```bash
npm install
npm run dev
```

Your application should now be running at `http://localhost:5173`

## Testing the Application

### Test Employer Flow:
1. Sign up with role "Hire Talent"
2. Post a job
3. View it in your dashboard

### Test Candidate Flow:
1. Sign up with role "Find a Job"
2. Upload a resume in your dashboard
3. Browse jobs and apply

## Troubleshooting

### Issue: "Missing Supabase environment variables"
- Make sure your `.env` file exists and has the correct values
- Restart the dev server after changing `.env`

### Issue: "Cannot upload resume"
- Verify the `resumes` bucket exists in Supabase Storage
- Check that the bucket is public
- Verify storage policies are set correctly

### Issue: "Cannot see jobs/applications"
- Check RLS policies in Supabase
- Make sure you're logged in
- Check browser console for errors

### Issue: Database tables don't exist
- The migrations should be applied automatically
- If not, check the Supabase dashboard under "Database" → "Migrations"

## Production Deployment

### Frontend (Netlify/Vercel)

1. Push your code to GitHub
2. Connect your repository to Netlify or Vercel
3. Configure build settings:
   - Build command: `npm run build`
   - Publish directory: `dist`
4. Add environment variables in the hosting dashboard
5. Deploy

### Environment Variables for Production

Make sure to add these in your hosting platform:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

## Security Notes

- Never commit your `.env` file
- Use different Supabase projects for development and production
- Regularly rotate your API keys
- Monitor usage in Supabase dashboard
- Review RLS policies to ensure data security

## Need Help?

- [Supabase Documentation](https://supabase.com/docs)
- [React Documentation](https://react.dev)
- [TailwindCSS Documentation](https://tailwindcss.com)
