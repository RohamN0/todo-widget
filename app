import tkinter as tk
from ttkbootstrap import Style
from ttkbootstrap.widgets import Treeview
import time, os

class TaskApp:
    def __init__(self, root, task_file=r"path/to/your/tasks.txt"):
        self.root = root
        self.root.title("Task Viewer")
        self.root.resizable(False, False)
        
        # Make it frameless (no title bar)
        self.root.overrideredirect(True)
        self.root.geometry(f"200x150+5+45")  # Widget size and left placement
        self.root.attributes("-topmost", True)  # Always on top

        # Apply a Modern Dark Mode Theme
        self.style = Style(theme="superhero")  # Use ttkbootstrap theme
        self.root.configure(bg=self.style.colors.bg)

        # Create a rounded corner effect
        self.create_rounded_corners()
        
        # Treeview with modern style
        self.tree = Treeview(root, bootstyle="dark")
        self.tree.pack(expand=True, fill="both", padx=5, pady=5)

        self.tree.heading("#0", text="Tasks", anchor="w")
        self.tree.column("#0", width=500)

        # Parse and display tasks
        self.tasks = self.parse_tasks(task_file)
        self.build_tree(self.tasks)

        # Bind animation effect
        self.tree.bind("<<TreeviewOpen>>", self.animate_expand)
        
        # Minimize with middle mouse button
        self.minimized = False
        self.root.bind("<Button-2>", self.toggle_minimize)  # Scroll click event
        
        # Right-Click Hover Text
        self.tree.bind("<Button-3>", self.show_tooltip)  # Right-click event
        self.tooltip = None
        
        self.tree.bind("<Button-1>", self.count_left_clicks)  # Detect triple-click
        self.click_count = 0  # Track left clicks

    def parse_tasks(self, filename):
        """Parses the text file into a hierarchical dictionary."""
        with open(filename, "r") as file:
            lines = file.readlines()

        stack = []  # Track hierarchy
        root_tasks = {}

        for line in lines:
            line = line.rstrip()
            if not line:
                continue
            
            indent_level = len(line) - len(line.lstrip())  # Count indentation
            task_name = line.lstrip().rstrip(":")  # Clean task name

            node = {"name": task_name, "subtasks": []}

            while stack and stack[-1][1] >= indent_level:
                stack.pop()

            if stack:
                stack[-1][0]["subtasks"].append(node)
            else:
                root_tasks[task_name] = node

            stack.append((node, indent_level))

        return root_tasks

    def build_tree(self, tasks, parent=""):
        """Recursively adds tasks to the Treeview with icons."""
        for task_name, task_data in tasks.items():
            task_id = self.tree.insert(parent, "end", text=" " + task_name, open=False)

            for subtask in task_data["subtasks"]:
                self.build_tree({subtask["name"]: subtask}, task_id)

    def animate_expand(self, event):
        """Creates a smooth animation effect when expanding a tree node."""
        item_id = self.tree.focus()
        if not item_id:
            return

        children = self.tree.get_children(item_id)
        for child in children:
            self.tree.item(child, open=True)
            self.root.update_idletasks()
            time.sleep(0.03)  # Faster animation
            
    def create_rounded_corners(self):
        """Applies rounded corners using a transparent window mask."""
        radius = 50  # Adjust for more/less rounding
        size = (400, 800)

        # Set window shape
        self.root.attributes("-transparentcolor", self.style.colors.bg)
        self.root.wm_attributes("-alpha", 1.0)

        # Apply shape using WM (Windows only)
        if os.name == "nt":
            from ctypes import windll
            hwnd = windll.user32.GetParent(self.root.winfo_id())
            windll.dwmapi.DwmSetWindowAttribute(hwnd, 2, 1, 4)
            windll.dwmapi.DwmSetWindowAttribute(hwnd, 3, 1, 4)

    def toggle_minimize(self, event):
        """Minimize to a small widget in the upper-left when middle-clicked."""
        if self.minimized:
            self.root.geometry(f"200x150+5+45")  # Restore size
            self.minimized = False
        else:
            self.root.geometry(f"100x40+920+0")  # Shrink to small widget
            self.minimized = True
        
    def show_tooltip(self, event):
        """Show tooltip when right-clicking a task."""
        item_id = self.tree.identify_row(event.y)
        if not item_id:
            return

        task_text = self.tree.item(item_id, "text")

        # Destroy any existing tooltip
        if self.tooltip:
            self.tooltip.destroy()

        # Create new tooltip
        self.tooltip = tk.Toplevel(self.root)
        self.tooltip.overrideredirect(True)
        self.tooltip.geometry(f"+{event.x_root+10}+{event.y_root+10}")

        label = tk.Label(self.tooltip, text=task_text, font=("JetBrains Mono", 12), 
            bg="black", fg="white", padx=30, pady=5, relief="solid", borderwidth=1)
        label.pack()

        # Auto destroy after 2 seconds
        self.tooltip.after(2000, self.tooltip.destroy)

    def count_left_clicks(self, event):
        """Count left clicks to detect triple-click (close app)."""
        self.click_count += 1
        if self.click_count == 3:
            self.root.quit()
            
        self.root.after(500, self.reset_click_count)  # Reset count after 500ms

    def reset_click_count(self):
        """Resets the click counter."""
        self.click_count = 0
        
# Run the application
if __name__ == "__main__":
    root = tk.Tk()
    app = TaskApp(root)
    root.mainloop()
