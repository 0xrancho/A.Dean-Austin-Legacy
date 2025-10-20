/**
 * Database types - corresponds to Supabase schema
 */

export interface UserProfile {
  id: string
  full_name: string | null
  role: 'user' | 'admin'
  created_at: string
  updated_at: string
}

export interface ArchiveDocument {
  id: number
  content: string
  metadata: Record<string, any> | null
  embedding: number[] | null
  created_at: string
}

export interface Submission {
  id: number
  user_id: string
  submission_type: 'story' | 'photo' | 'document' | 'fact'
  title: string
  description: string | null
  file_path: string | null
  date_mentioned: string | null
  people_mentioned: string | null
  status: 'pending' | 'approved' | 'rejected'
  admin_notes: string | null
  submitted_at: string
  reviewed_at: string | null
  reviewed_by: string | null
}

export interface Message {
  role: 'user' | 'assistant'
  content: string
  citations?: string[]
}

export interface ChatResponse {
  response: string
  citations: string[]
  sources: Array<{
    content: string
    metadata: Record<string, any>
  }>
}
