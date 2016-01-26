---
layout: post
title:  "Nested views with backbone and marionette"
date:   2015-01-26
categories: backbone, marionette, distilled tutorial
---

= Nested views with backbone and marionette =

TL;DR; Create 2 models and 2 collections and 2 `ItemView` and 2 `CollectionView`

Let's build the classic TODO application, but also let's group TODOs together.

1. Create the TODO model:
```Javascript
var Todo = Backbone.Model.extend({
    defaults: {
        title: 'A new TODO'
    }
});
```

2. Create the TODO List model:
```Javascript

var TodoList = Backbone.Collection.extend({
    model: Todo
});
```

3. Now we want to display our TODO list, so we create an `ItemView` to display each TODO and a `CollectionView`
 to display the list:
 ```Javascript
var TodoView = Backbone.Marionette.ItemView.extend({
    template: '#todo-template'
});

var TodoListView = Backbone.Marionette.CollectionView.extend({
    template: '#todolist-template',
    childView: TodoView
});
```

we are using very simple and basic templates:

```html
    <script type="text/template" id="todo-template">
        <div>Title: <%= title %></div>
    </script>

    <script type="text/template" id="todolist-template">
        <div id='todos'>
        </div>
    </script>
```

4. It's time to group TODOs together according to some priority. Backbone does not support nested collections,
so we must create an intermediate model with the relative collection:

```Javascript
var Priority = Backbone.Model.extend({
    defaults: {
        todoList: undefined,
        priorityLevel: 'Medium'
    }
});

var PriorityList = Backbone.Collection.extend({
    model: Priority
});
```

note the the `Priority` model has an attribute that will hold the relative TODO list.

5. And finally we create the views:
```Javascript
var PriorityView = Backbone.Marionette.ItemView.extend({
    template: '#priority-template',
    onAttach: function() {
        var todos = this.model.get('todoList'); // Get collection

        var todoListView = new TodoListView({ // Create view for this collection
            collection: todos
        });

        this.$('.todolist').append(todoListView.render().el); // Attach view to the DOM
    }
});

var PriorityListView = Backbone.Marionette.CollectionView.extend({
    template: '#prioritylist-template',
    childView: PriorityView
});
```

Note that we had to teach our `PriorityView` to display the inner `TodoListView` within the `onAttach` method.
 This is the only wiring we must do manually. All the rest happens automatically thanks to Backbone and Marionette.