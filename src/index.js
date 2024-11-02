document.addEventListener("DOMContentLoaded", () => {
  const todoInput = document.querySelector(".todo-input");
  const addButton = document.querySelector(".add-button");
  const todoList = document.querySelector(".todo-list");

  function createTodoItem(text, timestamp = new Date()) {
    const todoItem = document.createElement("div");
    todoItem.className = "todo-item";

    const checkbox = document.createElement("input");
    checkbox.type = "checkbox";
    checkbox.className = "todo-checkbox";
    checkbox.addEventListener("change", () => {
      todoItem.classList.toggle("completed", checkbox.checked);
    });

    const todoContent = document.createElement("div");
    todoContent.className = "todo-content";

    const todoText = document.createElement("p");
    todoText.className = "todo-text";
    todoText.textContent = text;

    const todoTimestamp = document.createElement("div");
    todoTimestamp.className = "todo-timestamp";
    todoTimestamp.textContent = formatTimestamp(timestamp);

    const deleteButton = document.createElement("button");
    deleteButton.className = "delete-button";
    deleteButton.textContent = "Delete";
    deleteButton.addEventListener("click", () => {
      todoItem.style.animation = "slideIn 0.3s ease-out reverse";
      setTimeout(() => todoItem.remove(), 300);
    });

    todoContent.appendChild(todoText);
    todoContent.appendChild(todoTimestamp);

    todoItem.appendChild(checkbox);
    todoItem.appendChild(todoContent);
    todoItem.appendChild(deleteButton);

    return todoItem;
  }

  function formatTimestamp(date) {
    return new Intl.DateTimeFormat("en-US", {
      year: "numeric",
      month: "short",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
      second: "2-digit",
    }).format(date);
  }

  function addTodo() {
    const text = todoInput.value.trim();
    if (text) {
      const todoItem = createTodoItem(text);
      todoList.insertBefore(todoItem, todoList.firstChild);
      todoInput.value = "";
    }
  }

  addButton.addEventListener("click", addTodo);
  todoInput.addEventListener("keyup", (e) => {
    if (e.key === "Enter") {
      addTodo();
    }
  });
});
