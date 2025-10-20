# M0: Memorial Site - Complete and Ready to Deploy

**Status:** ✅ Built and ready for deployment
**Location:** `/home/rancho/ArthurDean/memorial-site/`
**Target URL:** dean-austin.org
**Purpose:** Collect memories during Dean's wake and funeral

---

## What Was Built

A beautiful, simple memorial landing page with:

### Features
1. **Hero portrait** (circle frame)
2. **Memorial title**: "Arthur 'Dean' Austin - Digital Archive Coming Soon"
3. **"Submit a Memory" button** (large, centered)
4. **Modal form** with:
   - Name (required)
   - Email (required)
   - "Notify when archive ready?" checkbox (default: true)
   - Memory text area (required)
   - File upload (optional - photos/PDFs)
5. **Google reCAPTCHA v2** (invisible - spam protection)
6. **Auto-save to Supabase** (no approval needed)
7. **Thank you confirmation** after submission
8. **Fully responsive** (works on all devices)

### Tech Stack
- React + TypeScript + Vite
- TailwindCSS (beautiful, modern styling)
- Supabase (database + file storage)
- Google reCAPTCHA (spam protection)

---

## What You Need to Do

### 1. Run Database Setup (5 minutes)

Go to Supabase SQL Editor:
https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/editor

Open this file:
```
/home/rancho/ArthurDean/memorial-site/supabase-memorial-setup.sql
```

Copy entire contents → Paste in SQL Editor → Click "Run"

This creates:
- `memorial_submissions` table
- `memorial-submissions` storage bucket
- Public submission policies

### 2. Get reCAPTCHA Keys (5 minutes)

Go to: https://www.google.com/recaptcha/admin

1. Click "+" to create new site
2. Label: "Dean Austin Memorial"
3. Select: **reCAPTCHA v2 → Invisible reCAPTCHA badge**
4. Add domains:
   - `localhost` (for testing)
   - `dean-austin.org` (production)
5. Click Submit
6. Copy **Site Key** (you'll need this for .env)

### 3. Add Dean's Hero Portrait (2 minutes)

Place Dean's best portrait photo here:
```
/home/rancho/ArthurDean/memorial-site/public/hero-portrait.jpg
```

Recommended: 800x800px, cropped square

You can use any photo from the archive - it will be displayed in a circular frame.

### 4. Configure Environment Variables (3 minutes)

```bash
cd /home/rancho/ArthurDean/memorial-site
cp .env.example .env
nano .env
```

Fill in these three values:

```bash
VITE_SUPABASE_URL=https://pfhmxffrczflqqaqjqgr.supabase.co
VITE_SUPABASE_ANON_KEY=<get from https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/settings/api>
VITE_RECAPTCHA_SITE_KEY=<from step 2 above>
```

### 5. Test Locally (5 minutes)

```bash
cd /home/rancho/ArthurDean/memorial-site
npm install
npm run dev
```

Visit: http://localhost:5173

Test the flow:
1. Click "Submit a Memory"
2. Fill out form
3. Upload a test photo
4. Submit
5. Verify thank you message appears

Check Supabase to confirm submission:
```sql
select * from memorial_submissions order by submitted_at desc limit 1;
```

### 6. Deploy to Vercel (10 minutes)

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
cd /home/rancho/ArthurDean/memorial-site
vercel
```

Follow prompts (mostly just press Enter)

Then set environment variables in Vercel:
1. Go to https://vercel.com/dashboard
2. Find project → Settings → Environment Variables
3. Add all three variables from .env
4. Redeploy: `vercel --prod`

### 7. Connect dean-austin.org (15 minutes)

In Vercel Dashboard:
- Project → Settings → Domains
- Add `dean-austin.org`
- Follow DNS instructions

In your domain registrar (GoDaddy, Namecheap, etc.):
- Add A Record: `@` → `76.76.21.21`
- Add CNAME: `www` → `cname.vercel-dns.com`

Wait 10-30 minutes for DNS propagation.

Test: https://dean-austin.org

---

## Files Created

```
memorial-site/
├── src/
│   ├── components/
│   │   └── MemorialForm.tsx          # Submission form
│   ├── lib/
│   │   └── supabase.ts               # Supabase client
│   ├── App.tsx                        # Main landing page
│   └── index.css                      # Tailwind styles
├── public/
│   └── hero-portrait.jpg              # ADD THIS!
├── supabase-memorial-setup.sql        # Database setup
├── .env.example                       # Template
├── .env                               # CREATE THIS!
├── README.md                          # Full documentation
├── DEPLOYMENT_CHECKLIST.md            # Step-by-step guide
└── package.json
```

---

## Admin: Viewing Submissions

During the wake/funeral, view submissions in real-time:

Go to: https://app.supabase.com/project/pfhmxffrczflqqaqjqgr/editor

```sql
-- View all submissions
select
  id,
  name,
  email,
  notify_when_ready,
  submitted_at,
  memory
from memorial_submissions
order by submitted_at desc;

-- Count submissions
select count(*) from memorial_submissions;

-- View uploaded files
select * from storage.objects
where bucket_id = 'memorial-submissions';
```

---

## Next Steps After Memorial

1. **Export all submissions:**
   ```sql
   -- In Supabase SQL Editor
   select * from memorial_submissions;
   -- Export as CSV
   ```

2. **Download all files:**
   - Supabase Dashboard → Storage → memorial-submissions → Download all

3. **Migrate to full M1 archive:**
   - Import memories into M1 submission workflow
   - Admin approval for inclusion

---

## Quick Reference

**Local dev:** `npm run dev` → http://localhost:5173
**Deploy:** `vercel --prod`
**Supabase:** https://app.supabase.com/project/pfhmxffrczflqqaqjqgr
**reCAPTCHA:** https://www.google.com/recaptcha/admin

---

## Estimated Time to Deploy

- Database setup: 5 min
- Get reCAPTCHA keys: 5 min
- Add hero portrait: 2 min
- Configure .env: 3 min
- Test locally: 5 min
- Deploy to Vercel: 10 min
- Connect domain: 15 min
- Final testing: 5 min

**Total: ~50 minutes**

---

## Support

All documentation is in `/home/rancho/ArthurDean/memorial-site/`:
- `README.md` - Complete guide
- `DEPLOYMENT_CHECKLIST.md` - Step-by-step deployment
- `supabase-memorial-setup.sql` - Database script

The site is **ready to deploy**. Follow the 7 steps above and you'll have it live at dean-austin.org by end of week.

---

**In loving memory of Arthur "Dean" Austin**

This memorial site will honor his legacy and collect precious memories from family and friends.
