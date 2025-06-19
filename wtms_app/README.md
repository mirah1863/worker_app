# Worker Task Management System (WTMS)

This Flutter application is developed as the final project for the **STIWK2114 Mobile Programming** course. It helps workers manage their assigned tasks, submit work updates, and view submission history through a clean and user-friendly mobile interface.

## 🚀 Features

- 🔐 Worker Login & Registration
- 👤 View & Update Profile (except username)
- ✅ Task List with Submission Status
- 📝 Submit Work with Notes
- 📜 Submission History
- ✏️ Edit Previous Submissions
- 🔄 Tab Navigation (Tasks, History, Profile)
- 🎨 Clean and consistent UI styling

## 🧰 Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: PHP (REST API)
- **Database**: MySQL (via XAMPP)
- **Local Testing**: Chrome (Flutter Web)

## 🗃️ Database Tables

1. `workers`  
   - `id`, `username`, `full_name`, `email`, `phone`, `address`

2. `tbl_works`  
   - `id`, `title`, `description`, `status`, `assigned_to`, `date_assigned`, `due_date`

3. `tbl_submissions`  
   - `id`, `submission_text`, `submitted_at`, `worker_id`, `work_id`

## 🧪 How to Run

1. Clone the repository
2. Open with VS Code or Android Studio
3. Start XAMPP and place the `wtms_api` folder in your `htdocs`
4. Run on Chrome:
   ```bash
   flutter run -d chrome
