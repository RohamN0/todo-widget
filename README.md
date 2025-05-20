
# 📝 ToDo Widget

A minimal, modern, and highly focused **Tkinter-based ToDo widget** designed to stay out of your way — always on top, beautifully styled, with rounded corners and smooth expand animations.

---

## 🚀 Features

- ⚫ **Dark Mode UI** using `ttkbootstrap`’s `superhero` theme  
- 🌳 **Hierarchical Tasks** parsed from a simple indented text file  
- 📌 **Always on Top** frameless widget (perfect for sticking to the edge of your screen)  
- 🖱️ **Mouse Interactions:**
  - Right-click on a task → shows tooltip with task name
  - Middle-click (scroll button) → minimize to a tiny widget
  - Triple left-click → quit the app
- 🎬 **Smooth expand animation** when opening task branches
- 🎨 **Rounded corners** (Windows only)
- 🗂 Reads tasks from a txt file using Python-style indentation

---

## 📂 File Format

The app reads tasks from a plain `.txt` file with indentation-based structure. Example:

```
Project A:
  Subtask 1
  Subtask 2:
    Sub-subtask a
Project B:
  Research
```

---

## 📦 Requirements

- Python 3.7+
- [`ttkbootstrap`](https://pypi.org/project/ttkbootstrap/)

Install dependencies:

```bash
pip install ttkbootstrap
```

---

## 🛠️ Usage

1. Save your tasks to a txt file
2. Run the script:

```bash
python main.py
```

> The widget will appear on the left edge of your screen.

---

## 🖥️ Customization

You can change the path to your task file by modifying the constructor:

```python
app = TaskApp(root, task_file="path/to/your/tasks.txt")
```

---

## 🪟 Platform Notes

- Rounded corners and transparency currently only work on **Windows**
- App is always on top and non-resizable by design

---

## 💡 Inspiration

Inspired by the desire for a **distraction-free**, **quick-access**, **persistent** widget to track daily tasks, especially for programmers and power users.

---

## 📸 Screenshots

*(Add screenshots here if you’d like)*

---

## 📄 License

MIT License
