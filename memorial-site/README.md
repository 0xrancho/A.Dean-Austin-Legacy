# Arthur "Dean" Austin - Memorial Memory Collection Site

**M0: Memorial MVP for Wake & Funeral**

A simple, beautiful landing page for collecting memories, stories, and photos during Dean's wake and funeral.

## Purpose

This memorial site will be live at **dean-austin.org** during the wake and funeral to collect:
- Personal memories and stories
- Photos and documents
- Contact information for future archive notifications

All submissions are saved automatically to Supabase for later inclusion in the full digital archive (M1).

## Features

- ✅ Hero portrait and memorial title
- ✅ "Submit a Memory" button
- ✅ Simple form with:
  - Name (required)
  - Email (required)
  - Notify when archive ready (checkbox, default: true)
  - Memory/story text area (required)
  - File upload (optional: photos, PDFs, documents)
- ✅ Google reCAPTCHA v2 (invisible) spam protection
- ✅ Direct submission to Supabase
- ✅ Beautiful thank you confirmation
- ✅ Fully responsive (mobile-friendly)

## Quick Setup

### 1. Install Dependencies

```bash
npm install
```

### 2. Environment Variables

Create `.env` file in this directory:

```bash
# Copy from example
cp .env.example .env

# Edit with your values
nano .env
```

Required values:
- `VITE_SUPABASE_URL` - Your Supabase project URL
- `VITE_SUPABASE_ANON_KEY` - Your Supabase anon/public key
- `VITE_RECAPTCHA_SITE_KEY` - Your Google reCAPTCHA site key

**Get Supabase keys:** https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/settings/api

**Get reCAPTCHA keys:** https://www.google.com/recaptcha/admin (choose invisible reCAPTCHA v2)

### 3. Database Setup

Run the SQL setup in Supabase:

1. Go to: https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/editor
2. Open `supabase-memorial-setup.sql` in this directory
3. Copy all contents
4. Paste into Supabase SQL Editor
5. Click "Run"

This creates:
- `memorial_submissions` table
- `memorial-submissions` storage bucket
- Public access policies (anyone can submit)
- Admin-only view policies

### 4. Add Hero Portrait

Place Dean's hero portrait image as:
```
/public/hero-portrait.jpg
```

Recommended: 800x800px, circular crop looks best

### 5. Run Development Server

```bash
npm run dev
```

Visit: http://localhost:5173

### 6. Test Submission

1. Click "Submit a Memory"
2. Fill out the form
3. Complete reCAPTCHA
4. Submit
5. Check Supabase dashboard for the entry

## Deployment to dean-austin.org

### Option 1: Vercel (Recommended)

1. **Install Vercel CLI:**
   ```bash
   npm i -g vercel
   ```

2. **Deploy:**
   ```bash
   vercel
   ```

3. **Configure Environment Variables in Vercel:**
   - Go to Vercel Dashboard → Project Settings → Environment Variables
   - Add all three variables from `.env`
   - Redeploy

4. **Connect Custom Domain:**
   - Vercel Dashboard → Project → Settings → Domains
   - Add `dean-austin.org`
   - Follow DNS configuration instructions

### Option 2: Netlify

1. **Build the site:**
   ```bash
   npm run build
   ```

2. **Deploy `dist` folder** to Netlify

3. **Set environment variables** in Netlify dashboard

4. **Connect custom domain** dean-austin.org

### DNS Configuration (for dean-austin.org)

Point your domain to Vercel or Netlify:

**For Vercel:**
```
A Record: @ → 76.76.21.21
CNAME: www → cname.vercel-dns.com
```

**For Netlify:**
```
A Record: @ → (Netlify's IP)
CNAME: www → (your-site).netlify.app
```

## Viewing Submissions (Admin)

### Option 1: Supabase Dashboard

Go to: https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/editor

```sql
-- View all submissions
select
  id,
  name,
  email,
  notify_when_ready,
  submitted_at,
  substring(memory, 1, 100) as memory_preview
from memorial_submissions
order by submitted_at desc;

-- Count total submissions
select count(*) from memorial_submissions;

-- Download files
select * from storage.objects
where bucket_id = 'memorial-submissions';
```

### Option 2: Admin Panel (To Be Created)

Create a simple admin page at `/admin`:
- Login required (Supabase auth)
- View all submissions
- Download uploaded files
- Export as CSV

## Project Structure

```
memorial-site/
├── public/
│   └── hero-portrait.jpg      # Dean's portrait (add this!)
├── src/
│   ├── components/
│   │   └── MemorialForm.tsx   # Submission form modal
│   ├── lib/
│   │   └── supabase.ts        # Supabase client
│   ├── App.tsx                # Main landing page
│   ├── index.css              # Tailwind styles
│   └── main.tsx               # Entry point
├── .env                        # Environment variables (DO NOT COMMIT)
├── .env.example                # Template for .env
├── supabase-memorial-setup.sql # Database setup script
└── README.md                   # This file
```

## Customization

### Change Title or Text

Edit `src/App.tsx`:
- Line 24-26: Main title
- Line 28-30: Subtitle
- Line 32-37: Description text

### Change Colors

Edit button colors in `src/App.tsx` line 41:
```tsx
className="bg-blue-600 hover:bg-blue-700 ..."
```

Change to green: `bg-green-600 hover:bg-green-700`

### Add More Form Fields

Edit `src/components/MemorialForm.tsx` to add fields

Don't forget to update database table:
```sql
alter table memorial_submissions add column new_field text;
```

## Security Notes

- ✅ reCAPTCHA prevents spam submissions
- ✅ File uploads restricted to images and PDFs
- ✅ RLS policies prevent unauthorized data access
- ✅ No authentication required (intentionally public during memorial)
- ✅ Admin-only access to view submissions

## Post-Memorial

After the wake and funeral:

1. **Export all submissions:**
   ```sql
   copy memorial_submissions to '/tmp/memorial_submissions.csv' csv header;
   ```

2. **Download all uploaded files** from Supabase Storage

3. **Consider shutting down or redirecting** the site to the full M1 archive

4. **Migrate memories** to the full archive (M1) with admin approval

## Support Checklist

- [ ] Environment variables configured
- [ ] Database tables created
- [ ] Storage bucket created
- [ ] reCAPTCHA keys obtained
- [ ] Hero portrait added to `/public`
- [ ] Test submission completed successfully
- [ ] Deployed to production
- [ ] Custom domain connected
- [ ] SSL certificate active
- [ ] Mobile responsive tested
- [ ] Family members notified of URL

## Timeline

**Target:** Deploy by end of week for Dean's wake and funeral
**URL:** dean-austin.org
**Status:** M0 MVP - Memorial Collection Phase

---

**In loving memory of Arthur "Dean" Austin**
