# FORM VALIDATION

This module provides a robust and reusable framework for validating form fields in Dart/Flutter. It uses an abstract class to handle state (clean/dirty) and validation, making it easy to create extending classes for use with custom fields like emails, passwords, etc.

Classes that extend FormValidation must implement validation logic specific to their data type (e.g., email, password, username, etc.). This allows you to maintain a consistent structure throughout your code.

Let's look at an example of how the flow works:

1. The user types something into the text field.

2. Your Cubit or Bloc, Provider, or simply a variable using setState() receives the new value.

3. You call the constructor named EmailInput.dirty.

4. Inside EmailInput.dirty, a static method (\_validate) is called, which executes the validation logic for the value, for example, email.

5. The result of `_validate` (the error or `null`) is passed to the `super.dirty` constructor of the abstract class.

6. The abstract class `FormValidation` stores this result in the `_error` property.

7. From that point on, every time you access `isValid` or `error`, the class simply returns its existing state.

### **How ​​would you use it in your project?**

# 1. Define the abstract class:

Copy and paste the `FormValidation` class into a Dart file (`form_validation.dart`).

🔗 **[Link](./modules/domain/base/form_validation.dart)**

# 2. Create a class for each field and override methods:

For each form field you need, create a new class that extends `FormValidation`. For example:

🔗 **[Link](./modules/form_validation/presentation/input/email_input.dart)**

- class Email extends FormValidation, for email validation.

- class Password extends FormValidation, for password validation.

- class Username extends FormValidation, for username validation.

This example shows the implementation for validating the email field.

**Some explanations:**

- **Error status (\_error)**: The abstract class has a private property \_error that stores the validation result.

- **Constructors**: The dirty constructor requires the error (E? error) as an argument.
  The class that extends it (Email.dirty) is responsible for calculating the error and passing it.

- **Getter Methods**: The `error` and `isValid` getters simply return the state stored in the `_error` property.

- **Private Method**: `_validate` validates the form input and passes the new value to the `_error` property if an error occurs; otherwise, the value will be `null`.

# 3. Use classes in your business logic:

In a Cubit, Bloc, or simply a StatefulWidget, you use instances of these classes to manage the state of your fields.

**Example using a StatefulWidget**
🔗 **[Full Example](./modules/form_validation/presentation/screen/sign_in_screen.dart)**
