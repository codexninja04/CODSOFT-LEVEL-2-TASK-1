# Deployment Guide

This guide covers deploying your Job Board application to production.

## Prerequisites

- GitHub account
- Netlify or Vercel account
- Supabase project (production instance)

## Deployment Steps

### 1. Prepare Production Supabase Project

1. Create a new Supabase project for production (separate from development)
2. The database migrations have already been applied
3. Set up the `resumes` storage bucket (see SETUP.md)
4. Copy your production credentials:
   - Project URL
   - Anon key

### 2. Push Code to GitHub

```bash
git init
git add .
git commit -m "Initial commit: Job Board application"
git remote add origin <your-github-repo-url>
git push -u origin main
```

### 3. Deploy to Netlify

#### Option A: Using Netlify CLI

1. Install Netlify CLI:
```bash
npm install -g netlify-cli
```

2. Login to Netlify:
```bash
netlify login
```

3. Initialize and deploy:
```bash
netlify init
netlify deploy --prod
```

#### Option B: Using Netlify Dashboard

1. Go to [Netlify](https://netlify.com)
2. Click "Add new site" → "Import an existing project"
3. Connect to your GitHub repository
4. Configure build settings:
   - Build command: `npm run build`
   - Publish directory: `dist`
5. Add environment variables:
   - Go to Site settings → Environment variables
   - Add:
     - `VITE_SUPABASE_URL`: Your production Supabase URL
     - `VITE_SUPABASE_ANON_KEY`: Your production anon key
6. Click "Deploy site"

### 4. Deploy to Vercel (Alternative)

1. Go to [Vercel](https://vercel.com)
2. Click "Add New Project"
3. Import your GitHub repository
4. Configure project:
   - Framework Preset: Vite
   - Build command: `npm run build`
   - Output directory: `dist`
5. Add environment variables:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
6. Click "Deploy"

### 5. Configure Custom Domain (Optional)

#### On Netlify:
1. Go to Site settings → Domain management
2. Click "Add custom domain"
3. Follow DNS configuration instructions

#### On Vercel:
1. Go to Project settings → Domains
2. Add your custom domain
3. Configure DNS records as instructed

## Post-Deployment

### 1. Test Your Application

Visit your deployed URL and test:
- User registration (both roles)
- Job posting (as employer)
- Job browsing and search
- Job application (as candidate)
- Resume upload
- Dashboard functionality

### 2. Configure Email Templates (Supabase)

1. Go to Supabase dashboard → Authentication → Email Templates
2. Customize:
   - Confirmation email
   - Password reset email
   - Magic link email (if using)

### 3. Set Up Monitoring

#### Netlify Analytics
1. Go to your site in Netlify
2. Enable Analytics in the site settings

#### Supabase Monitoring
1. Monitor database usage in Supabase dashboard
2. Check API requests
3. Monitor storage usage

### 4. Enable Custom Authentication Domain (Optional)

For production, you may want to use a custom domain for authentication:
1. Go to Supabase → Authentication → Settings
2. Add your custom domain under "Site URL"

## Environment-Specific Configuration

### Development
```env
VITE_SUPABASE_URL=https://dev-project.supabase.co
VITE_SUPABASE_ANON_KEY=dev-anon-key
```

### Production
```env
VITE_SUPABASE_URL=https://prod-project.supabase.co
VITE_SUPABASE_ANON_KEY=prod-anon-key
```

## Continuous Deployment

Both Netlify and Vercel support automatic deployments:

1. Push to your main branch triggers a production deployment
2. Pull requests create preview deployments
3. Configure branch deploys in your hosting dashboard

### GitHub Actions (Optional)

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build
        env:
          VITE_SUPABASE_URL: ${{ secrets.VITE_SUPABASE_URL }}
          VITE_SUPABASE_ANON_KEY: ${{ secrets.VITE_SUPABASE_ANON_KEY }}

      - name: Deploy to Netlify
        uses: netlify/actions/cli@master
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
        with:
          args: deploy --prod
```

## Security Checklist

- [ ] Different Supabase projects for dev and prod
- [ ] Environment variables configured correctly
- [ ] RLS policies tested and working
- [ ] Storage bucket policies configured
- [ ] HTTPS enabled (automatic with Netlify/Vercel)
- [ ] API keys never committed to git
- [ ] Regular backups configured in Supabase

## Performance Optimization

### 1. Enable Caching

Add `netlify.toml` or `vercel.json`:

**netlify.toml**:
```toml
[[headers]]
  for = "/assets/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/*.js"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/*.css"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"
```

### 2. Optimize Images

If you add images later:
- Use WebP format
- Implement lazy loading
- Use appropriate sizes

### 3. Database Optimization

- Add indexes to frequently queried columns (already done)
- Monitor slow queries in Supabase
- Consider connection pooling for high traffic

## Troubleshooting Production Issues

### Issue: Build fails
- Check build logs in hosting dashboard
- Verify all dependencies are in package.json
- Test build locally: `npm run build`

### Issue: Environment variables not working
- Redeploy after adding/changing variables
- Check variable names match exactly
- Verify no typos in values

### Issue: Database connection fails
- Verify Supabase URL is correct
- Check API key is the anon key (not service role)
- Verify RLS policies allow access

## Scaling Considerations

As your application grows:

1. **Database**: Upgrade Supabase plan for more connections
2. **Storage**: Monitor and upgrade storage limits
3. **CDN**: Consider using Cloudflare for additional caching
4. **Database Optimization**: Add more indexes as needed
5. **API Rate Limits**: Monitor and upgrade Supabase plan

## Backup and Recovery

### Database Backups
- Supabase Pro plan includes daily backups
- Can restore to any point in time
- Export data regularly for additional safety

### Code Backups
- Always maintained in GitHub
- Tag releases for easy rollback
- Use semantic versioning

## Support and Monitoring

Set up monitoring for:
1. Uptime (Netlify/Vercel provides this)
2. Error tracking (consider Sentry)
3. Performance metrics
4. Database usage (Supabase dashboard)

## Cost Estimation

### Free Tier Limits
- **Supabase Free**: 500MB database, 1GB storage, 50MB file uploads
- **Netlify Free**: 100GB bandwidth, 300 build minutes
- **Vercel Free**: 100GB bandwidth, unlimited deployments

### When to Upgrade
- Database size exceeds 500MB → Supabase Pro ($25/mo)
- Need more bandwidth → Netlify Pro ($19/mo) or Vercel Pro ($20/mo)
- Need team features → Upgrade both platforms

## Maintenance

Regular tasks:
1. Update dependencies monthly: `npm update`
2. Review Supabase logs weekly
3. Monitor error rates
4. Check security advisories
5. Update Node.js version as needed
6. Review and optimize RLS policies

Your Job Board application is now ready for production use!
