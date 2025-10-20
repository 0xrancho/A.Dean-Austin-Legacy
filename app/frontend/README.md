# Arthur Dean Austin Archive - Frontend

React + TypeScript + Vite frontend for the Arthur Dean Austin Digital Archive.

## Setup

### Install Dependencies

```bash
npm install
```

### Environment Variables

Create a `.env` file in the project root (`/home/rancho/ArthurDean/.env`):

```bash
VITE_SUPABASE_URL=https://pfhmxffrczflqqaqjqgr.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key_here
VITE_API_URL=http://localhost:8000
```

### Run Development Server

```bash
npm run dev
```

Visit: http://localhost:5173

## Available Scripts

- `npm run dev` - Start development server with hot reload
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint

## Project Structure

```
src/
├── components/          # React components
│   ├── auth/           # Authentication components
│   ├── chat/           # Chat interface components
│   ├── archive/        # Archive browsing components
│   ├── submission/     # Memory submission components
│   └── admin/          # Admin dashboard components
├── lib/                 # Libraries and utilities
│   ├── supabase.ts     # Supabase client
│   └── api.ts          # API client functions
├── types/               # TypeScript type definitions
│   └── database.ts     # Database types
├── App.tsx             # Main app component
├── main.tsx            # App entry point
└── index.css           # Global styles (Tailwind)
```

## Tech Stack

- **React 18** - UI library
- **TypeScript** - Type safety
- **Vite** - Build tool
- **TailwindCSS** - Styling
- **@supabase/supabase-js** - Supabase client
- **React Router** (to be added) - Routing

## Development Guidelines

### Component Structure

Follow this pattern for new components:

```typescript
// src/components/example/ExampleComponent.tsx
interface ExampleComponentProps {
  title: string
  onAction: () => void
}

export function ExampleComponent({ title, onAction }: ExampleComponentProps) {
  return (
    <div className="p-4">
      <h2 className="text-xl font-bold">{title}</h2>
      <button
        onClick={onAction}
        className="mt-2 px-4 py-2 bg-blue-500 text-white rounded"
      >
        Action
      </button>
    </div>
  )
}
```

### Using Supabase Client

```typescript
import { supabase } from '@/lib/supabase'

// Query data
const { data, error } = await supabase
  .from('archive_documents')
  .select('*')
  .limit(10)

// Auth
const { user } = await supabase.auth.getUser()
```

### Calling Backend API

```typescript
const response = await fetch('http://localhost:8000/api/search', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`
  },
  body: JSON.stringify({ query: 'search term' })
})

const data = await response.json()
```

## Upcoming Features

### M3: Authentication
- Login/Signup forms
- Auth context provider
- Protected routes
- User profile display

### M4: Chat Interface
- Chat UI with message history
- Story card components
- Citation display
- Loading states

### M5: Archive Browser
- Folder tree component
- Document viewer
- Image lightbox
- Markdown rendering

### M6: Memory Submission
- Submission form
- File upload
- Form validation
- Success/error handling

### M7: Admin Dashboard
- Submission list
- Approval/rejection UI
- Admin-only routes
- Real-time updates

## Styling with TailwindCSS

Use Tailwind utility classes:

```tsx
<div className="container mx-auto px-4 py-8">
  <h1 className="text-3xl font-bold text-gray-900 mb-4">
    Title
  </h1>
  <p className="text-gray-600 leading-relaxed">
    Content
  </p>
</div>
```

Common patterns:
- Layout: `flex`, `grid`, `container`, `mx-auto`
- Spacing: `p-4`, `m-2`, `space-x-4`, `gap-4`
- Typography: `text-xl`, `font-bold`, `leading-relaxed`
- Colors: `bg-blue-500`, `text-gray-900`, `border-gray-300`
- Interactive: `hover:bg-blue-600`, `focus:ring-2`

## Troubleshooting

**Module not found errors**
```bash
rm -rf node_modules package-lock.json
npm install
```

**Types not working**
- Check `tsconfig.json` includes proper paths
- Restart TypeScript server in VSCode

**Vite not detecting .env changes**
- Restart dev server after changing .env
- Ensure .env is in project root, not frontend folder

---

**Status:** M1 Complete, Ready for M2-M9 implementation
