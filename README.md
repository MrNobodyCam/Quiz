# Quiz System Project

This project is a quiz management system designed in Dart. The system supports creating quizzes with multiple question types, tracks participant results, and enforces single or multiple answer choices as per the question type. The project includes a UML diagram and its implementation in Dart.

---

## Project Objectives

1. **UML Diagram Design**:
   - Design a UML class diagram that models a quiz system.
   - The system manages a `Quiz` containing multiple `Question` objects.
   - Questions are of two types:
     - **SingleChoice**: Only one answer is correct.
     - **MultipleChoice**: Multiple answers can be correct.
   - Each `Question` includes:
     - A title and answer options.
     - Unique answers based on the question type.
   - Track participant results for each quiz.

2. **Implementation in Dart**:
   - Implement the UML design in Dart.
   - Display quiz results for each participant, including their score.
   - Enforce answer limitations:
     - SingleChoice questions allow only one answer.
     - MultipleChoice questions allow multiple answers.

---

## Class Diagram (UML)

The UML diagram models the quiz system’s components. Key classes include:
- **Quiz**: Holds and manages `Question` objects.
- **Question** (Abstract Class): Base class for all questions.
  - **SingleChoice** (inherits `Question`): Enforces a single correct answer.
  - **MultipleChoice** (inherits `Question`): Supports multiple correct answers.
- **User**: Represents quiz participants.
- **Result**: Stores each participant's quiz score.

---

## Project Structure

The project includes the following main classes:
- `Quiz`: Manages the list of questions and participants.
- `Question`: Abstract class with shared properties like question text and options.
  - `SingleChoice`: Allows one correct answer.
  - `MultipleChoice`: Allows multiple correct answers.
- `User`: Stores participant details (first name and last name).
- `Result`: Stores and calculates the participant's score based on their answers.

---

## Getting Started

### Prerequisites

- Dart SDK installed.
- A Dart-compatible IDE (e.g., Visual Studio Code, Android Studio).

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/MrNobodyCam/Quiz.git
