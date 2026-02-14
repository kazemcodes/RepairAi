# RepairAI - Design Document

**Date**: 2026-02-14  
**Version**: 1.0.0  
**Status**: Approved

---

## 1. Project Overview

**RepairAI** is a cross-platform mobile repair assistant application that uses AI to help technicians find problems and solutions for device repairs. The app is designed for mobile repair shops and technicians, providing three core features: Schematic Viewer, Solution Finder, and AI Chatbox.

### Key Principles
- **Open Source**: Community-driven content and contributions
- **Free**: No cost to users, community enriches the AI
- **Cross-Platform**: Windows desktop and Android mobile
- **AI-Powered**: Leverages Gemini and OpenRouter APIs

---

## 2. Technical Architecture

### 2.1 Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.x (Dart) |
| State Management | Riverpod (flutter_riverpod) |
| Backend | Supabase (PostgreSQL, Auth, Storage, Edge Functions) |
| AI Services | Google Gemini API + OpenRouter API |
| Local Storage | Drift (SQLite) |
| Website | Next.js (Static export) |
| Hosting | GitHub Pages / Vercel |

### 2.2 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── api_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── app_colors.dart
│   ├── utils/
│   │   ├── extensions.dart
│   │   └── helpers.dart
│   └── errors/
│       ├── exceptions.dart
│       └── failures.dart
├── features/
│   ├── schematic/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── pages/
│   │       └── widgets/
│   ├── solution/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── chatbox/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── settings/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── community/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── auth/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/
│   ├── widgets/
│   └── services/
└── main.dart
```

### 2.3 Clean Architecture Layers

Each feature follows:
- **Data Layer**: Datasources (remote/local), Repository implementations
- **Domain Layer**: Entities, Repository interfaces, Use cases
- **Presentation Layer**: Riverpod providers, Pages, Widgets

---

## 3. Core Features

### 3.1 Schematic Viewer

**Purpose**: View and interact with circuit diagrams stored in GitHub

**Storage**: GitHub repository (community-managed)
- Schematics stored as community contributions
- App downloads and caches locally for offline use
- Updates via GitHub synchronization

**Capabilities**:
- Load schematics from GitHub repository
- Zoom and pan on diagrams
- Search by device model, manufacturer
- Community uploads via GitHub PR

**Data Model**:
```
Schematic {
  id: String (UUID)
  title: String
  deviceModel: String
  manufacturer: String
  fileUrl: String (GitHub raw URL)
  fileType: String (png, jpg, svg, pdf)
  createdBy: String
  createdAt: DateTime
}
```

### 3.2 Solution Finder

**Purpose**: Searchable repair solutions with AI-generated indexing

**AI Role**: 
- AI analyzes solution images and generates text descriptions/tags
- Index stored in GitHub for community access
- User searches solutions by text, views related images

**Capabilities**:
- Search solutions by problem/symptom
- View related solution images
- AI-generated index/description for each solution image
- Community-contributed solutions

**Data Model**:
```
Solution {
  id: String (UUID)
  problem: String
  deviceModel: String
  steps: List<String>
  tools: List<String>
  difficulty: String (easy, medium, hard)
  images: List<String> (URLs)
  aiIndex: String (AI-generated description)
  createdBy: String
  createdAt: DateTime
}
```

### 3.3 Chatbox (AI Assistant)

**Purpose**: Text-based AI chat for repair queries

**Constraints**: Text-only (no voice input)

**Capabilities**:
- Text-based natural language repair queries
- References community data and AI-created index
- Multi-model support (Gemini, OpenRouter)
- Conversation history (stored in Supabase)
- Model switching in settings

**Data Model**:
```
ChatMessage {
  id: String (UUID)
  role: String (user, assistant)
  content: String
  timestamp: DateTime
  model: String
}

ChatSession {
  id: String (UUID)
  title: String
  messages: List<ChatMessage>
  createdAt: DateTime
  updatedAt: DateTime
}
```

---

## 4. Settings Feature

### 4.1 API Key Management

| Setting | Description | Required |
|---------|-------------|----------|
| Gemini API Key | Google Gemini AI | Yes (one required) |
| OpenRouter API Key | Alternative AI models | Optional |
| Default Model | Preferred AI model | No |

### 4.2 Other Settings

- Theme (Light/Dark/System)
- Language
- Offline mode toggle
- Cache management
- Data sync preferences

### 4.3 Security

- API keys stored securely (encrypted in local storage)
- Keys never sent to third-party servers (direct AI API calls)

---

## 5. Community & GitHub Integration

### 5.1 Data Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Community  │────▶│   App/API   │────▶│  GitHub PR  │
│  Submissions │     │  Moderation │     │  Workflow   │
└─────────────┘     └─────────────┘     └─────────────┘
                                               │
       ┌────────────────────────────────────────┘
       ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   index.json│◀────│  AI Indexer  │◀────│   Scraped   │
│  (GitHub)   │     │   Service    │     │    Data     │
└─────────────┘     └─────────────┘     └─────────────┘
```

### 5.2 Community Submission System

**Via App**:
- User submits schematics, docs, solutions, ideas
- Moderation queue in Supabase
- Approved submissions → Auto-generate GitHub PR
- Workflow merges and updates `index.json`

**Via GitHub**:
- Direct PR to repository
- Community can fork and contribute
- Automated CI/CD validation

### 5.3 Web & Telegram Scraping

**Data Sources**:
- Telegram groups/channels (repair communities)
- Websites (repair guides, forums)
- AI processes scraped data

**Process**:
1. Scraping service runs (Edge Function or separate service)
2. AI analyzes content → extracts repair knowledge
3. User validates processed data
4. Auto-PR to GitHub with validated data

### 5.4 GitHub Workflow (index.json)

**Structure**:
```json
{
  "version": "1.0.0",
  "updated_at": "2026-02-14",
  "schematics": [
    {"path": "schematics/iphone-14/pro...", "type": "schematic", "hash": "..."}
  ],
  "solutions": [
    {
      "path": "solutions/...", 
      "images": [...], 
      "index": "...",
      "hash": "..."
    }
  ]
}
```

**Automation**:
- GitHub Actions workflow triggers on PR
- Validates data format
- Runs AI indexing
- Updates index.json
- Auto-merges on success

### 5.5 User Uploads

**Types**:
- Schematic images (PNG, JPG, SVG, PDF)
- Solution documents (text, markdown)
- Ideas/suggestions (text)
- Solution images (for AI indexing)

---

## 6. Website & Landing Page

### 6.1 Sections

1. **Hero**: App name, tagline, download buttons
2. **Features**: Brief overview of 3 core features
3. **Community**: Link to GitHub, contribution guide
4. **Download**: Windows (.exe) and Android (.apk) buttons
5. **Footer**: GitHub repo link, license (MIT)

### 6.2 Tech Stack

- Static site generator: Next.js
- Hosting: GitHub Pages or Vercel
- Auto-deploy on main branch updates

### 6.3 Download Sources

- GitHub Releases for latest builds
- Direct links in landing page

---

## 7. Repository Structure

```
repairai/
├── app/                    # Flutter app source
├── website/               # Landing page source (Next.js)
├── data/                  # Community data templates
├── .github/
│   └── workflows/
│       └── index-update.yml  # Auto-update workflow
├── index.json             # Main index (auto-generated)
├── README.md
└── LICENSE (MIT)
```

---

## 8. Database Schema (Supabase)

### Tables

```sql
-- Users
create table users (
  id uuid primary key,
  email text unique,
  username text,
  avatar_url text,
  created_at timestamptz default now()
);

-- Schematics (local cache reference)
create table schematics (
  id uuid primary key,
  title text not null,
  device_model text,
  manufacturer text,
  github_path text,
  file_type text,
  created_by uuid references users(id),
  created_at timestamptz default now()
);

-- Solutions
create table solutions (
  id uuid primary key,
  problem text not null,
  device_model text,
  steps text[],
  tools text[],
  difficulty text,
  images text[],
  ai_index text,
  created_by uuid references users(id),
  created_at timestamptz default now()
);

-- Chat sessions
create table chat_sessions (
  id uuid primary key,
  user_id uuid references users(id),
  title text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Chat messages
create table chat_messages (
  id uuid primary key,
  session_id uuid references chat_sessions(id),
  role text not null,
  content text not null,
  model text,
  created_at timestamptz default now()
);

-- Community submissions (moderation queue)
create table submissions (
  id uuid primary key,
  type text not null, -- schematic, solution, idea
  status text default 'pending', -- pending, approved, rejected
  content jsonb,
  submitted_by uuid references users(id),
  created_at timestamptz default now()
);
```

---

## 9. Implementation Phases

### Phase 1: Foundation
- Flutter project setup with Clean Architecture
- Supabase integration
- Basic authentication
- Settings page (API keys)

### Phase 2: Core Features
- Schematic viewer (GitHub sync)
- Solution finder (search)
- Chatbox (basic AI chat)

### Phase 3: Community
- User submissions
- Moderation system
- GitHub PR automation

### Phase 4: Data Enrichment
- Telegram/website scraping
- AI indexing service
- index.json workflow

### Phase 5: Website
- Landing page
- GitHub release integration
- Documentation

---

## 10. Success Criteria

- [ ] App builds successfully for Windows and Android
- [ ] Users can view schematics from GitHub
- [ ] Users can search and view solutions
- [ ] AI chatbox responds to repair queries
- [ ] Settings save API keys securely
- [ ] Community can submit content via app
- [ ] GitHub workflow updates index.json
- [ ] Landing page loads with download links
- [ ] Offline mode works for cached content
