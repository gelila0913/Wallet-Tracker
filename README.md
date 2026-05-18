# Flutter Clean Architecture CRUD Application

A production-ready Flutter application demonstrating complete **CRUD (Create, Read, Update, Delete)** operations. The project consumes a live, publicly available REST API using the **Dio** network client and implements the modern **Bloc** state management ecosystem following absolute **Clean Architecture** patterns.

---

## 🛠️ Tech Stack & Architecture Blueprint

This application implements **Clean Architecture** by separating the software into isolated layers (Data, Domain, and Presentation). This decoupling ensures that the core business rules are completely independent of external packages, databases, and UI components, making the codebase scalable, maintainable, and highly testable.

### Core Stack
* **State Management:** `flutter_bloc` (v8.1+) & `equatable`
* **HTTP Network Client:** `dio` (v5.4+)
* **Architecture Rules:** Feature-First Clean Architecture (Data ➔ Domain ➔ Presentation)
* **API Target Endpoint:** JSONPlaceholder REST API (`https://jsonplaceholder.typicode.com/posts`)

### Architectural Layers
1. **Domain Layer:** The independent core containing the blueprint definition contract. It holds business rules, entity models (`PostEntity`), and abstract repository boundaries.
2. **Data Layer:** The infrastructure implementation. It manages the serialization models (`PostModel`), remote data sources (`PostRemoteDataSource`), and concrete repository implementations handling error code transformations.
3. **Presentation Layer:** The UI visual canvas and reactive states. It encapsulates the core business logic components (`PostBloc`), interactive view screens, responsive layout elements, and user form dialogues.

---
## 🖥️ Viewport & Feature Specifications

### 1. Central Analytics Dashboard (`DashboardPage`)
The **Dashboard** acts as the core entry point and analytical control hub for the application. It aggregates raw data from both your expenses and debit/credit ledger records to present a high-level summary of your current financial posture.

* **Key Components & Layout:** * Features an elegant welcome panel displaying user tracking profiles.
* **State Management Handling:** Listens to global provider scopes to ensure calculated aggregate counters reflect live updates across disparate data layers immediately.
<img width="499" height="610" alt="image" src="https://github.com/user-attachments/assets/adc1aefb-0c80-4320-b221-8b2585c8ff24" />

---

### 2. Expense Ledger System (`ExpensesPage`)
The **Expenses** view is built explicitly around capturing, tracking, and breaking down personal outlays. This screen is backed by a remote web API pipeline to store continuous operational costs.

* **Key Components & Layout:**
  * Uses a modular list view that fetches live, asynchronous historical records over the internet.
  * Integrates interactive creation forms to quickly post and publish fresh outlays.
  * Incorporates proper visual fallbacks, including full-screen `CircularProgressIndicator` elements during network transit and reactive error states with retry actions if endpoints timeout.
* **State Management Handling:** Utilizes `ExpenseBloc` streams to transition smoothly through lifecycle states (`ExpenseLoading`, `ExpenseLoaded`, `ExpenseError`), decoupling remote web service actions from view rendering.
<img width="493" height="602" alt="image" src="https://github.com/user-attachments/assets/5c47099f-6b1d-4973-9bd2-fe2d0735592b" />

---

### 3. Lending & Credit Matrix (`TransactionsPage`)
The **Transactions** interface handles the modular peer-to-peer tracking of outstanding liabilities (**"You Owe"** vs. **"They Owe"**). This view implements flexible layouts optimized to prevent text squishing or clipping on smaller device screens.

* **Key Components & Layout:**
  * **Dynamic Aggregate Balance Cards:** High-contrast tracking blocks showing total pending currency amounts (`ETB`) and record counts for debt distributions.
  * **Integrated Text Filters:** An operational search field to filter records dynamically by personal names.
  * **Status & Settlement Badges:** Individual item records include stylized status tags (**You Owe** in soft red vs. **They Owe** in soft green, paired with a secondary toggle badge for **Pending** or **Paid** conditions).
  * **Action Controls:** Houses checkmark buttons to rapidly mark items as settled, alongside dedicated context keys for editing fields or deleting records entirely.
* **State Management Handling:** Driven by the root-provided `TransactionBloc`. It seamlessly intercepts user actions—such as tapping item checkmarks to fire a status toggle event—and updates state objects to maintain architectural integrity.
* <img width="499" height="609" alt="image" src="https://github.com/user-attachments/assets/9ac381fe-0bb2-4fb1-8cf8-f18f7b3312d3" />


## 📂 Complete Project Directory Structure

Below is the absolute file structure mapping of the application workspace inside the `lib/` root folder:

```text
lib/
├── core/
│   ├── errors/
│   │   └── failures.dart              # Core translation maps for exceptions
│   └── network/
│       └── dio_client.dart            # Central configuration wrapper for Dio instance
├── features/
│   └── posts/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── post_remote_datasource.dart # Raw network implementation
│       │   ├── models/
│       │   │   └── post_model.dart             # JSON serialization logic
│       │   └── repositories/
│       │       └── post_repository_impl.dart   # Implements domain contract
│       ├── domain/
│       │   ├── entities/
│       │   │   └── post_entity.dart            # Core structural business model
│       │   └── repositories/
│       │       └── post_repository.dart        # Abstract repository contract
│       └── presentation/
│           ├── bloc/
│           │   ├── post_bloc.dart              # Core controller brain
│           │   ├── post_event.dart             # UI event interface streams
│           │   └── post_state.dart             # Visual state definitions
│           ├── pages/
│           │   └── posts_page.dart             # Main screen display grid
│           └── widgets/
│               ├── post_card_item.dart         # Reusable card component
│               └── post_form_dialog.dart       # Form layout context helper
└── main.dart                                  # Global root configuration container

## 👥 Developed by

This application was engineered and compiled as part of the formal Software Engineering evaluation curriculum.

* **Developer:** Gelila Sintayehu  
* **Section:** Section-2  
* **Student ID:** UGR/3508/16  
* **Institution:** Addis Ababa University, Science and Technology Campus (AAiT)

---
