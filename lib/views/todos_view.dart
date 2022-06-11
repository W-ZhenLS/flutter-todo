import 'dart:ui';

import 'package:date_field/date_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_demo/common/constant.dart';
import 'package:flutter_todo_demo/models/todo_model.dart';
import 'package:flutter_todo_demo/services/todos_service.dart';
import 'package:flutter_todo_demo/view_models/todos_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TodosView extends StatelessWidget {
  const TodosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodosViewModel todosViewModel = context.watch<TodosViewModel>();

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.amberAccent,
              indicatorWeight: 3.0,
              tabs: [
                Tab(
                  text: 'Todos',
                  iconMargin: EdgeInsets.all(5.0),
                ),
                Tab(text: 'History'),
              ],
            ),
            title: const Text('Todo Items'),
            centerTitle: true,
          ),
          drawer: null,
          body: TabBarView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Todos of the day (${todosViewModel.todosOfTheDay.length})',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: buildCreateTodoButton(context, todosViewModel),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      height: 210,
                      child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: todosViewModel.todosOfTheDay.length,
                        itemBuilder: (BuildContext context, int index) {
                          TodosModel currentTodos =
                              todosViewModel.todosOfTheDay[index];

                          return buildTodoItemCard(
                              index, currentTodos, context, todosViewModel);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Incoming Tasks (${todosViewModel.todoList.length})',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      height: 210,
                      child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: todosViewModel.todoList.length,
                        itemBuilder: (BuildContext context, int index) {
                          TodosModel currentTodos =
                              todosViewModel.todoList[index];

                          return buildTodoItemCard(
                              index, currentTodos, context, todosViewModel);
                        },
                      ),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Completed Todos (${todosViewModel.completedTodos.length})',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      height: 560,
                      child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: todosViewModel.completedTodos.length,
                        itemBuilder: (BuildContext context, int index) {
                          TodosModel currentTodos =
                              todosViewModel.completedTodos[index];

                          return SizedBox(
                            height: 70.0,
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 35.0, vertical: 5.0),
                              elevation: 2.0,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Text('${index + 1}.'),
                                      ),
                                      const VerticalDivider(),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('${currentTodos.title}'),
                                              Text(
                                                  '${currentTodos.description}'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(DateFormat('dd MMM yyyy')
                                              .format(currentTodos.date!))),
                                    ],
                                  )),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  SizedBox buildCreateTodoButton(
      BuildContext context, TodosViewModel todosViewModel) {
    return SizedBox(
      child: TextButton.icon(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                GlobalKey<FormState> createTodoFormKey = GlobalKey<FormState>();

                // Reset todoToCreate
                todosViewModel.todoToCreate.title = "";
                todosViewModel.todoToCreate.description = "";
                todosViewModel.todoToCreate.date = DateTime.now();

                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 2.0,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(60.0, 40.0, 20.0, 0),
                      child: Form(
                          key: createTodoFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Create Todo',
                                  style: categoryTitleStyle),
                              const SizedBox(height: 80.0),
                              Padding(
                                padding: const EdgeInsets.only(right: 100),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Title'),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                        onChanged: ((value) {
                                          todosViewModel.todoToCreate.title =
                                              value;
                                        }),
                                        maxLines: 1,
                                        cursorHeight: 24.0,
                                        decoration: textFormFieldDecor,
                                        validator: (value) => value!.isEmpty
                                            ? 'Cannot be empty'
                                            : null,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction),
                                    const SizedBox(height: 20.0),
                                    const Text('Description'),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                        // initialValue: todoToCreate.description,
                                        onChanged: ((value) => todosViewModel
                                            .todoToCreate.description = value),
                                        maxLines: 1,
                                        cursorHeight: 24.0,
                                        decoration: textFormFieldDecor,
                                        validator: (value) => value!.isEmpty
                                            ? 'Cannot be empty'
                                            : null,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction),
                                    const SizedBox(height: 20.0),
                                    const Text('Effective Date'),
                                    const SizedBox(height: 8),
                                    DateTimeFormField(
                                      // initialValue: currentTodos.date,
                                      dateFormat: DateFormat('dd MMMM yyyy'),
                                      decoration: textFormFieldDecor.copyWith(
                                          suffixIcon:
                                              const Icon(Icons.event_note),
                                          hintText: 'Select effective date'),
                                      mode: DateTimeFieldPickerMode.date,
                                      validator: (value) => value == null
                                          ? 'Cannot be empty'
                                          : null,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      onDateSelected: (DateTime value) {
                                        DateFormat dateFormat =
                                            DateFormat('yyyy-MM-dd');
                                        todosViewModel.todoToCreate.date =
                                            DateTime.parse(
                                                dateFormat.format(value));
                                      },
                                    ),
                                    const SizedBox(height: 40.0),
                                    const Divider(),
                                    const SizedBox(height: 40.0),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              width: 150,
                                              height: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.redAccent),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: const Text(
                                                "CANCEL",
                                                style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          InkWell(
                                            onTap: () async {
                                              bool isCreationSuccess = false;
                                              if (createTodoFormKey
                                                  .currentState!
                                                  .validate()) {
                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Details Confirmation'),
                                                        content: const Text(
                                                            "Are you sure that all details are correct?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                              'CANCEL',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .redAccent),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                (() async {
                                                              isCreationSuccess =
                                                                  await todosViewModel
                                                                      .createTodo();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }),
                                                            child: const Text(
                                                                'YES'),
                                                          )
                                                        ],
                                                      );
                                                    });
                                                Navigator.of(context).pop();

                                                if (isCreationSuccess) {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return const ActionSuccessDialog();
                                                      });

                                                  // Refresh todos after editing
                                                  await todosViewModel
                                                      .getOngoingTodos();
                                                  await todosViewModel
                                                      .getTodosOfTheDay();
                                                } else {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return const ActionFailedDialog();
                                                      });
                                                }
                                              }
                                            },
                                            child: Container(
                                              width: 150,
                                              height: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                border: Border.all(width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: const Text(
                                                "Create Todo",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 40.0)
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                );
              });
        },
        icon: const Icon(Icons.add),
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Create New Todo',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        style: TextButton.styleFrom(
            // primary: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(width: 1.0))),
      ),
    );
  }

  SizedBox buildTodoItemCard(int index, TodosModel currentTodos,
      BuildContext context, TodosViewModel todosViewModel) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return SizedBox(
      height: 70.0,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 5.0),
        elevation: 2.0,
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text('${index + 1}.'),
                ),
                const VerticalDivider(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${currentTodos.title}'),
                        Text('${currentTodos.description}'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Text(
                        DateFormat('dd MMM yyyy').format(currentTodos.date!))),
                Row(
                  children: [
                    // Edit todos button
                    buildEditTodoButton(
                        todosViewModel, currentTodos, context, formKey),

                    const SizedBox(width: 20.0),

                    // Complete todos button
                    buildCompleteTodoButton(
                        context, currentTodos, todosViewModel),

                    const SizedBox(width: 20.0),

                    // Remove todos button
                    buildRemoveTodoButton(
                        context, currentTodos, todosViewModel),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  IconButton buildEditTodoButton(
      TodosViewModel todosViewModel,
      TodosModel currentTodos,
      BuildContext context,
      GlobalKey<FormState> formKey) {
    return IconButton(
      icon: const Icon(Icons.edit),
      tooltip: 'Edit todos',
      onPressed: () {
        // Initialize value of TodoToUpdate model
        todosViewModel.todoToUpdate.title = currentTodos.title;
        todosViewModel.todoToUpdate.description = currentTodos.description;
        todosViewModel.todoToUpdate.date = currentTodos.date;
        todosViewModel.todoToUpdate.isCompleted = currentTodos.isCompleted;

        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 2.0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60.0, 40.0, 20.0, 0),
                    child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Edit Todo Details',
                                style: categoryTitleStyle),
                            const SizedBox(height: 80.0),
                            Padding(
                              padding: const EdgeInsets.only(right: 100),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Title'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                      initialValue: currentTodos.title,
                                      onChanged: ((value) {
                                        todosViewModel.todoToUpdate.title =
                                            value;
                                      }),
                                      maxLines: 1,
                                      cursorHeight: 24.0,
                                      decoration: textFormFieldDecor,
                                      validator: (value) => value!.isEmpty
                                          ? 'Cannot be empty'
                                          : null,
                                      autovalidateMode:
                                          AutovalidateMode.always),
                                  const SizedBox(height: 20.0),
                                  const Text('Description'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                      initialValue: currentTodos.description,
                                      onChanged: ((value) => todosViewModel
                                          .todoToUpdate.description = value),
                                      maxLines: 1,
                                      cursorHeight: 24.0,
                                      decoration: textFormFieldDecor,
                                      validator: (value) => value!.isEmpty
                                          ? 'Cannot be empty'
                                          : null,
                                      autovalidateMode:
                                          AutovalidateMode.always),
                                  const SizedBox(height: 20.0),
                                  const Text('Effective Date'),
                                  const SizedBox(height: 8),
                                  DateTimeFormField(
                                    initialValue: currentTodos.date,
                                    dateFormat: DateFormat('dd MMMM yyyy'),
                                    decoration: textFormFieldDecor.copyWith(
                                        suffixIcon:
                                            const Icon(Icons.event_note),
                                        hintText: 'Select effective date'),
                                    mode: DateTimeFieldPickerMode.date,
                                    validator: (value) => value == null
                                        ? 'Cannot be empty'
                                        : null,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    onDateSelected: (DateTime value) {
                                      DateFormat dateFormat =
                                          DateFormat('yyyy-MM-dd');
                                      todosViewModel.todoToUpdate.date =
                                          DateTime.parse(
                                              dateFormat.format(value));
                                    },
                                  ),
                                  const SizedBox(height: 40.0),
                                  const Divider(),
                                  const SizedBox(height: 40.0),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.redAccent),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: const Text(
                                              "CANCEL",
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        InkWell(
                                          onTap: () async {
                                            bool isUpdateSuccess = false;
                                            if (formKey.currentState!
                                                .validate()) {
                                              await showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Details Confirmation'),
                                                      content: const Text(
                                                          "Are you sure that all details are correct?"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            'CANCEL',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .redAccent),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: (() async {
                                                            String todoId =
                                                                currentTodos.id
                                                                    .toString();
                                                            isUpdateSuccess =
                                                                await todosViewModel
                                                                    .updateTodoById(
                                                                        todoId);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }),
                                                          child:
                                                              const Text('YES'),
                                                        )
                                                      ],
                                                    );
                                                  });
                                              Navigator.of(context).pop();

                                              if (isUpdateSuccess) {
                                                await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return const ActionSuccessDialog();
                                                    });

                                                // Refresh todos after editing
                                                await todosViewModel
                                                    .getOngoingTodos();
                                                await todosViewModel
                                                    .getTodosOfTheDay();
                                              } else {
                                                await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return const ActionFailedDialog();
                                                    });
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              border: Border.all(width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: const Text(
                                              "Update Changes",
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 40.0)
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              );
            });
      },
    );
  }

  IconButton buildRemoveTodoButton(BuildContext context,
      TodosModel currentTodos, TodosViewModel todosViewModel) {
    return IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.redAccent,
      ),
      tooltip: 'Remove todos',
      onPressed: () async {
        bool isRemovedSuccess = false;

        await showDialog(
            context: context,
            builder: (context) {
              String todoId = currentTodos.id.toString();

              return AlertDialog(
                title: const Text('Remove Todo Record'),
                content: Text(
                    'Are you sure to remove ${currentTodos.title} record?'),
                actions: [
                  TextButton(
                      child: const Text('YES'),
                      onPressed: () async {
                        isRemovedSuccess =
                            await todosViewModel.removeTodoById(todoId);
                        Navigator.of(context).pop();

                        if (!isRemovedSuccess) {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return const ActionFailedDialog();
                              });
                        } else {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return const ActionSuccessDialog();
                              });

                          await todosViewModel.getOngoingTodos();
                          await todosViewModel.getTodosOfTheDay();
                        }
                      }),
                ],
              );
            });
      },
    );
  }

  IconButton buildCompleteTodoButton(BuildContext context,
      TodosModel currentTodos, TodosViewModel todosViewModel) {
    return IconButton(
      icon: const Icon(Icons.check),
      tooltip: 'Complete todos',
      onPressed: () async {
        bool isCompleteSuccess = false;

        await showDialog(
            context: context,
            builder: (context) {
              String todoId = currentTodos.id.toString();

              return AlertDialog(
                title: const Text('Complete Todo'),
                content: Text(
                    'Are you sure to complete ${currentTodos.title} record?'),
                actions: [
                  TextButton(
                    child: const Text('YES'),
                    onPressed: () async {
                      isCompleteSuccess =
                          await todosViewModel.completeTodoById(todoId);
                      Navigator.of(context).pop();

                      // In case complete todo action failed
                      if (!isCompleteSuccess) {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return const ActionFailedDialog();
                            });
                      } else {
                        // In case successfully completed todos, refresh todos and history
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const ActionSuccessDialog();
                            });
                        // Reload todos and history
                        await todosViewModel.getOngoingTodos();
                        await todosViewModel.getTodosOfTheDay();
                        await todosViewModel.getCompletedTodos();
                      }
                    },
                  )
                ],
              );
            });
      },
    );
  }
}

class ActionFailedDialog extends StatelessWidget {
  const ActionFailedDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Action Failed',
        style: TextStyle(color: Colors.redAccent),
      ),
      content: const Text('Action failed. Please try again later'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'))
      ],
    );
  }
}

class ActionSuccessDialog extends StatelessWidget {
  const ActionSuccessDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Action Success',
        style: TextStyle(color: Colors.green),
      ),
      content: const Text('Action Success. Changes have been made.'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'))
      ],
    );
  }
}
