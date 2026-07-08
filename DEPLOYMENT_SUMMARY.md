# Calcutta Node: 2026 Integrated Deployment Summary

This document outlines how your Website and Mobile App are "attached" using shared free-tier resources.

## 1. Shared Database (MongoDB Atlas)
- **Status:** **CONNECTED**
- Both the Website and Mobile App use the same MongoDB Cluster: `Cluster0`.
- Database Name: `calcuttanode`.
- Changes made in the App (like a new order or user) will reflect instantly on the Website's Admin Dashboard.

## 2. Central API (Render)
- **Production URL:** `https://calcuttanode-api.onrender.com`
- This single API serves both platforms.
- **Website (Vercel):** Communicates with this API for data.
- **Mobile App:** Communicates with the same API.
- **Note:** On the Render Free Tier, the API "sleeps" after 15 mins. The first app open might take 30 seconds to load; this is normal for free hosting.

## 3. GitHub Repository Structure
- **Repo 1 (Web + Server):** `https://github.com/danishkagit/calcuttanode.git`
  - Contains the React Website and the primary Node.js Server.
- **Repo 2 (Mobile App):** `https://github.com/danishkagit/calcuttanode-apps.git`
  - Contains the Flutter source code and the APK.

## 4. Mobile App Readiness
- **Config:** `lib/constants/config.dart` has been updated to use the Production API.
- **Backend Sync:** The `backend/` folder in this repo has been synchronized with the website's secrets (JWT, Razorpay, Cloudinary) to ensure shared login sessions.

## 5. Next Steps for You
1. **Push Changes:**
   - In `Calcutta Node` folder: `git add . && git commit -m "Sync API config" && git push origin main`
   - In `Calcutta Node App` folder: `git add . && git commit -m "Link to production API" && git push origin main`
2. **APK Installation:**
   - The file `calcuttanode-app.apk` is ready for distribution. You can send this to users directly.

---
*Configured for Calcutta Node by AI Assistant - 2026*
