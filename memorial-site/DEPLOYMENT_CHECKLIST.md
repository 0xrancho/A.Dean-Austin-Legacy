# M0 Memorial Site - Deployment Checklist

Deploy by end of week for Dean's wake and funeral.

## Pre-Deployment Tasks

### 1. Database Setup
- [ ] Run `supabase-memorial-setup.sql` in Supabase SQL Editor
- [ ] Verify `memorial_submissions` table created
- [ ] Verify `memorial-submissions` storage bucket created
- [ ] Test RLS policies (anon can insert, admin can select)

### 2. Get API Keys

#### Supabase Keys
- [ ] Go to: https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/settings/api
- [ ] Copy `VITE_SUPABASE_URL`
- [ ] Copy `VITE_SUPABASE_ANON_KEY` (anon/public key)

#### Google reCAPTCHA Keys
- [ ] Go to: https://www.google.com/recaptcha/admin
- [ ] Click "+" to create new site
- [ ] Select "reCAPTCHA v2" → "Invisible reCAPTCHA badge"
- [ ] Add domain: `dean-austin.org` (and `localhost` for testing)
- [ ] Copy Site Key → `VITE_RECAPTCHA_SITE_KEY`
- [ ] Copy Secret Key (keep secure, not needed for frontend-only)

### 3. Add Hero Portrait
- [ ] Find Dean's best portrait photo
- [ ] Crop to square (800x800px recommended)
- [ ] Save as `/home/rancho/ArthurDean/memorial-site/public/hero-portrait.jpg`
- [ ] Optimize file size (< 500KB)

### 4. Configure Environment
- [ ] Create `.env` file in `/memorial-site/`:
  ```bash
  cd /home/rancho/ArthurDean/memorial-site
  cp .env.example .env
  nano .env
  ```
- [ ] Fill in all three values (Supabase URL, Supabase Anon Key, reCAPTCHA Site Key)

### 5. Local Testing
- [ ] Run `npm install`
- [ ] Run `npm run dev`
- [ ] Visit http://localhost:5173
- [ ] Click "Submit a Memory"
- [ ] Fill out form completely
- [ ] Upload a test photo
- [ ] Submit successfully
- [ ] Verify thank you message appears
- [ ] Check Supabase dashboard for entry:
  ```sql
  select * from memorial_submissions order by submitted_at desc limit 1;
  ```
- [ ] Check file uploaded to storage:
  ```sql
  select * from storage.objects where bucket_id = 'memorial-submissions';
  ```
- [ ] Test on mobile device (responsive design)

## Deployment to Vercel

### 1. Install Vercel CLI
```bash
npm i -g vercel
```

### 2. Deploy
```bash
cd /home/rancho/ArthurDean/memorial-site
vercel
```

Follow prompts:
- [ ] Set up and deploy? **Yes**
- [ ] Which scope? (choose your account)
- [ ] Link to existing project? **No**
- [ ] Project name? **dean-austin-memorial**
- [ ] Directory? **./memorial-site** (or press Enter if already in that dir)
- [ ] Override settings? **No**

### 3. Set Environment Variables in Vercel

Go to: https://vercel.com/dashboard

- [ ] Find your project: `dean-austin-memorial`
- [ ] Settings → Environment Variables
- [ ] Add three variables:
  - `VITE_SUPABASE_URL` = your_supabase_url
  - `VITE_SUPABASE_ANON_KEY` = your_anon_key
  - `VITE_RECAPTCHA_SITE_KEY` = your_recaptcha_key
- [ ] Select all environments (Production, Preview, Development)
- [ ] Save

### 4. Redeploy with Environment Variables
```bash
vercel --prod
```

- [ ] Wait for deployment to complete
- [ ] Note the deployment URL (e.g., `dean-austin-memorial.vercel.app`)

### 5. Test Production Deployment
- [ ] Visit the Vercel URL
- [ ] Test full submission flow
- [ ] Verify in Supabase that submission appears
- [ ] Check file upload works

## Connect Custom Domain

### 1. Add Domain in Vercel
- [ ] Vercel Dashboard → Project → Settings → Domains
- [ ] Add `dean-austin.org`
- [ ] Add `www.dean-austin.org`
- [ ] Vercel will show DNS configuration instructions

### 2. Update DNS Records

Go to your domain registrar (GoDaddy, Namecheap, etc.):

**For dean-austin.org:**
- [ ] Add A Record:
  - **Type:** A
  - **Name:** @ (or leave blank)
  - **Value:** `76.76.21.21`
  - **TTL:** Auto or 3600

- [ ] Add CNAME Record:
  - **Type:** CNAME
  - **Name:** www
  - **Value:** `cname.vercel-dns.com.`
  - **TTL:** Auto or 3600

### 3. Wait for DNS Propagation
- [ ] Wait 5-60 minutes for DNS to propagate
- [ ] Check status at: https://dnschecker.org
- [ ] Search for `dean-austin.org`

### 4. Verify SSL Certificate
- [ ] Visit https://dean-austin.org
- [ ] Check for SSL lock icon in browser
- [ ] Vercel auto-issues SSL (Let's Encrypt)

### 5. Final Production Test
- [ ] Visit https://dean-austin.org
- [ ] Test on desktop browser
- [ ] Test on mobile browser
- [ ] Submit a test memory
- [ ] Verify it appears in Supabase

## Post-Deployment

### 1. Update reCAPTCHA Domains
- [ ] Go back to: https://www.google.com/recaptcha/admin
- [ ] Edit your site
- [ ] Ensure `dean-austin.org` is in domain list
- [ ] Save

### 2. Admin Access Setup
- [ ] Create your admin account in Supabase:
  - Go to: https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/auth/users
  - Add user
- [ ] Promote to admin:
  ```sql
  update user_profiles set role = 'admin' where id = '<your-user-id>';
  ```

### 3. Monitoring & Support
- [ ] Bookmark Supabase dashboard for checking submissions
- [ ] Test viewing submissions as admin:
  ```sql
  select * from memorial_submissions order by submitted_at desc;
  ```
- [ ] Set up notifications (optional):
  - Supabase Webhooks → notify on new memorial_submissions

### 4. Share with Family
- [ ] Send URL to family members: https://dean-austin.org
- [ ] Provide context: "This is for collecting memories during the wake/funeral"
- [ ] Share on funeral programs/announcements

## Backup Plan

If dean-austin.org DNS doesn't work in time:
- [ ] Use Vercel preview URL: `dean-austin-memorial.vercel.app`
- [ ] Create short link: bit.ly/dean-austin-memorial
- [ ] Share temporary URL at wake/funeral

## Support During Event

Have ready:
- [ ] Laptop with internet access
- [ ] Mobile hotspot (backup)
- [ ] Supabase dashboard open (to monitor submissions)
- [ ] QR code to dean-austin.org (for easy mobile access)

## Post-Event Tasks

- [ ] Export all submissions from Supabase
- [ ] Download all uploaded files
- [ ] Thank participants via email (using notify_when_ready list)
- [ ] Begin migrating to full M1 archive

---

## Quick Reference

**Site URL:** https://dean-austin.org
**Vercel Dashboard:** https://vercel.com/dashboard
**Supabase Dashboard:** https://app.supabase.com/project/pfhmxffrczflqqaqjqgr
**reCAPTCHA Admin:** https://www.google.com/recaptcha/admin

**View Submissions:**
```sql
select * from memorial_submissions order by submitted_at desc;
```

**Emergency Contact:** (your phone/email)

---

**Timeline:** Deploy by end of week
**Purpose:** Collect memories during Dean's wake and funeral
**Status:** [ ] Not Started | [ ] In Progress | [ ] LIVE ✅
