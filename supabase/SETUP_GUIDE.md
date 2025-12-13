# Blogify Supabase Setup Guide

## Quick Setup Steps

### 1. Create Storage Buckets

Go to **Storage** in Supabase Dashboard and create two buckets:

#### Bucket 1: Blog Images
- **Bucket Name**: `blog_images`
- **Public bucket**: YES (toggle ON)
- **File size limit**: 5MB
- **Allowed MIME types**: `image/jpeg, image/png, image/gif, image/webp`

#### Bucket 2: Profile Avatars
- **Bucket Name**: `profile_avatars`
- **Public bucket**: YES (toggle ON)
- **File size limit**: 2MB
- **Allowed MIME types**: `image/jpeg, image/png, image/gif, image/webp`

### 2. Storage Policies

After creating the buckets, add these policies:

#### Blog Images Policies

```sql
-- Public read access for blog images
CREATE POLICY "Public Access blog_images"
ON storage.objects FOR SELECT
USING (bucket_id = 'blog_images');

-- Authenticated users can upload blog images
CREATE POLICY "Authenticated users can upload blog images"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'blog_images'
    AND auth.role() = 'authenticated'
);

-- Users can update their own blog images
CREATE POLICY "Users can update own blog images"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'blog_images'
    AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Users can delete their own blog images
CREATE POLICY "Users can delete own blog images"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'blog_images'
    AND auth.uid()::text = (storage.foldername(name))[1]
);
```

#### Profile Avatars Policies

```sql
-- Public read access for profile avatars
CREATE POLICY "Public Access profile_avatars"
ON storage.objects FOR SELECT
USING (bucket_id = 'profile_avatars');

-- Authenticated users can upload their own avatar
CREATE POLICY "Users can upload own avatar"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'profile_avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Users can update their own avatar
CREATE POLICY "Users can update own avatar"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'profile_avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Users can delete their own avatar
CREATE POLICY "Users can delete own avatar"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'profile_avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
);
```

### 3. Test Users (Already Created)

The following test users are already configured:

| Email | Password | UUID |
|-------|----------|------|
| hmdy7486@gmail.com | Mahmoud21@! | b32f7dde-a60a-412b-b476-674b659e1966 |
| admin@admin.com | admin@admin.com | 7706012e-a55d-429f-af67-0f1a7dcc08bc |

**Note**: These users must exist in Supabase Auth before running the seed data.

### 4. Run Schema SQL

Go to **SQL Editor** and run `schema.sql`:
- Creates `profiles` and `blogs` tables
- Sets up Row Level Security policies
- Creates triggers for auto-profile creation

### 5. Run Seed Data SQL

Go to **SQL Editor** and run `seed_data.sql` to insert test data.

---

## Configuration Summary

| Item | Value |
|------|-------|
| **Storage Bucket** | `blog_images` |
| **Bucket Visibility** | Public |
| **Database Tables** | `profiles`, `blogs` |
| **RLS Enabled** | Yes (both tables) |

---

## Test Login Credentials

You can use any of these accounts to test the app:

```
Email: hmdy7486@gmail.com
Password: Mahmoud21@!

Email: admin@admin.com
Password: admin@admin.com
```

---

## Sample Blog Images (Unsplash URLs)

The seed data uses these professional Unsplash images:

| Topic | Image URL |
|-------|-----------|
| AI/Technology | https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800&q=80 |
| Mobile Dev | https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800&q=80 |
| Programming | https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&q=80 |
| Business | https://images.unsplash.com/photo-1553028826-f4804a6dba3b?w=800&q=80 |
| Sleep/Health | https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=800&q=80 |
| Travel | https://images.unsplash.com/photo-1528181304800-259b08848526?w=800&q=80 |
| Gaming | https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=800&q=80 |
| Food | https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=800&q=80 |
| Nature | https://images.unsplash.com/photo-1448375240586-882707db888b?w=800&q=80 |
| Music | https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800&q=80 |
| Fashion | https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&q=80 |
| Books | https://images.unsplash.com/photo-1512820790803-83ca734da794?w=800&q=80 |

---

## Troubleshooting

### Images not loading?
- Verify bucket is set to **Public**
- Check storage policies are applied
- Verify image URLs are correct

### Authentication errors?
- Check Supabase URL and Anon Key in `.env`
- Verify users exist in Authentication dashboard
- Check RLS policies are enabled

### Profiles not created on signup?
- Verify the trigger `on_auth_user_created` exists
- Check `handle_new_user()` function is created

### Blogs not showing?
- Run `SELECT * FROM blogs;` to verify data
- Check `poster_id` matches actual user UUIDs
- Verify RLS policy allows SELECT
