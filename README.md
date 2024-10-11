# Flutter To-Do App

A simple yet powerful to-do app built using Flutter, which allows users to manage tasks efficiently. This app features task sorting and filtering based on priority, project categorization, and seamless task management functionality.

## Features

- **Task Management**: Add, edit, and delete tasks.
- **Task Filtering**: Filter tasks by priority (Low, Medium, High, Urgent).
- **Task Sorting**: Automatically sort tasks based on priority.
- **Project-Based Tasks**: Organize tasks under specific projects.
- **Task Details**: View and manage detailed information about each task.

## Getting Started

To get started with this app, follow these instructions.

### Prerequisites

Ensure you have the following installed:

- Flutter SDK
- Dart SDK
- Android Studio or Xcode (for iOS development)
- A device or emulator to run the app

### Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/dev-arham/todo_app.git
    ```

2. Navigate to the project directory:
    ```bash
    cd todo_app
    ```

3. Fetch the dependencies:
    ```bash
    flutter pub get
    ```

4. Add your API key by creating a new file named `api_key.dart` in the `lib/` folder:
    ```dart
    const String myAPIKey = 'YOUR_API_KEY_HERE';
    ```

5. Run the app on your device or emulator:
    ```bash
    flutter run
    ```

## API Configuration

This app integrates with the [Todoist API](https://developer.todoist.com/rest/v2/) to manage tasks and projects. Here's a breakdown of the API integration:

- **API Base URL**: `https://api.todoist.com/rest/v2/`
- **Endpoints**:
  - `/tasks`: To fetch, create, update, and delete tasks.
  - `/projects`: To fetch a list of projects.

- **Authentication**: The app uses a Bearer token (`myAPIKey`) for authorization. Make sure to replace `myAPIKey` in the `api_key.dart` file with your actual Todoist API token.

- **Headers**: 
  ```json
  {
    "Content-Type": "application/json",
    "Authorization": "Bearer <YOUR_API_KEY>"
  }
  ```

- **Task Operations**:
  - **Get Tasks**: Fetch all tasks using a GET request.
  - **Add Task**: Create a new task using a POST request with the required fields (`content`, `description`, and `priority`).
  - **Update Task**: Edit task details via a POST request by passing the task ID.
  - **Delete Task**: Remove a task using the task ID in the DELETE request.

## File Structure

```bash
lib/
├── models/
│   ├── project_model.dart         # Model for projects
│   └── task_model.dart            # Model for tasks
├── pages/
│   ├── home_page.dart             # Main homepage UI
│   ├── add_task_page.dart         # Page to add or edit tasks
│   ├── project_page.dart          # Page to display tasks under a project
│   └── task_details_page.dart     # Page to view task details
├── services/
│   └── api_key.dart               # API key file (excluded from GitHub for security)
│   └── api_services.dart          # API service for managing tasks and projects
└── main.dart                      # Main application entry point
```

## Key Components

### Home Page (`home_page.dart`)

The home page displays the user's tasks and provides the following functionality:
- **Drawer** for selecting projects.
- **Add Task Button** for adding new tasks.
- **Task Grid** displaying all tasks with details such as title, description, and priority.
- **Filtering by Priority** to show tasks with specific priority levels.

### API Services (`api_services.dart`)

Manages API requests such as:
- Fetching tasks and projects.
- Adding, updating, or deleting tasks.

## Future Improvements

- User authentication for personalized task management.
- Push notifications for task reminders.
- Task categorization by deadlines.
  
## Contributing

Feel free to submit issues or pull requests if you'd like to contribute to the project.

## License

This project is licensed under the MIT License.

---
