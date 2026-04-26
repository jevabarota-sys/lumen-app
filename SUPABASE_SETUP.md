# Supabase Setup Guide for Lumen App

This guide will help you set up Supabase for the Lumen mobile app backend.

## Prerequisites
- Supabase account (https://supabase.com)
- Access to your Supabase project dashboard

## Step 1: Create Supabase Project

1. Go to https://supabase.com and sign in
2. Click "New Project"
3. Choose your organization
4. Enter project details:
   - **Name**: `lumen-app`
   - **Database Password**: Generate a strong password (save this!)
   - **Region**: Choose closest to your users
5. Click "Create new project"
6. Wait for project to be provisioned (2-3 minutes)

## Step 2: Set Up Database Schema

1. In your Supabase dashboard, go to **SQL Editor**
2. Click "New query"
3. Copy and paste the entire contents of `supabase_schema.sql`
4. Click "Run" to execute the schema
5. Verify tables were created in **Table Editor**

Expected tables:
- `users` - User profiles and subscription status
- `journal_entries` - AI reflection journal entries
- `tarot_draws` - Daily tarot card draws
- `growth_paths` - User progress tracking
- `subscriptions` - Stripe payment management
- `community_posts` - Community feed content
- `daily_activities` - AI-generated daily activities

## Step 3: Configure Authentication

1. Go to **Authentication** > **Settings**
2. Under **Site URL**, add your app domains:
   - `http://localhost:3000` (for development)
   - Your production domain (when deployed)
3. Under **Auth Providers**, enable:
   - **Email** (already enabled)
   - **Google** (optional, for social login)
   - **Apple** (optional, for iOS social login)

## Step 4: Set Up Row Level Security (RLS)

The schema already includes RLS policies, but verify they're active:

1. Go to **Authentication** > **Policies**
2. Verify policies exist for all tables
3. Key policies include:
   - Users can only access their own data
   - Community posts require approval to be visible
   - Subscription data is user-specific

## Step 5: Get API Keys

1. Go to **Settings** > **API**
2. Copy these values for your app configuration:
   - **Project URL** (e.g., `https://your-project.supabase.co`)
   - **anon public** key (for client-side usage)
   - **service_role** key (for server-side operations - keep secret!)

## Step 6: Configure Environment Variables

Add these to your CI/CD secrets and local environment:

```bash
# Required for app functionality
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here

# Optional: for server-side operations
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here
```

### For GitHub Actions (CI/CD):
1. Go to your GitHub repo > **Settings** > **Secrets and variables** > **Actions**
2. Add repository secrets:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`

### For Local Development:
Create `.env` file in project root:
```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

## Step 7: Test Connection

1. Update `lib/core/constants/app_constants.dart` with your Supabase URL and key
2. Run the app locally: `flutter run`
3. Try creating an account to test authentication
4. Check Supabase dashboard to see if user was created

## Step 8: Enable Realtime (Optional)

For real-time features like community feed updates:

1. Go to **Database** > **Replication**
2. Enable replication for tables that need real-time updates:
   - `community_posts`
   - `daily_activities`

## Security Checklist

- ✅ RLS enabled on all tables
- ✅ Policies restrict data access to authenticated users
- ✅ anon key used for client-side (safe to expose)
- ✅ service_role key kept secret (server-side only)
- ✅ Site URLs configured for your domains
- ✅ Database password is strong and secure

## Troubleshooting

### Common Issues:

1. **"Invalid API key"**
   - Verify SUPABASE_URL and SUPABASE_ANON_KEY are correct
   - Check for extra spaces or quotes in environment variables

2. **"Row Level Security policy violation"**
   - Ensure user is authenticated before accessing data
   - Check RLS policies in Supabase dashboard

3. **"Table doesn't exist"**
   - Verify schema was executed successfully
   - Check Table Editor in Supabase dashboard

4. **Authentication not working**
   - Verify Site URL includes your app domain
   - Check email confirmation settings

## Next Steps

After Supabase is configured:
1. Set up Stripe integration for payments
2. Configure AI services for journal analysis
3. Test all app features end-to-end
4. Deploy to app stores

---

**Need help?** Check the [Supabase documentation](https://supabase.com/docs) or contact the development team.
