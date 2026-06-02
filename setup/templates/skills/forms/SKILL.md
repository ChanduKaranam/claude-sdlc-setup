---
name: forms
description: Use when building or modifying any form in {{PROJECT_NAME}}. Covers validation, submission patterns, error mapping, and UX conventions.
---
# Forms — {{PROJECT_NAME}}

## Stack

- **Form library**: {{FORM_LIB}}
- **Validation**: {{VALIDATION_LIB}} schemas (defined in `{{SHARED_SCHEMAS_PATH}}`)
- **Error mapping**: server errors mapped to field-level errors on the form

## Validation UX

- Validate on **blur** first, not on every keystroke.
- Show errors **inline under the field** — never as a modal or toast.
- On submit: validate all fields, focus the first errored field.
- On server error: map error codes to field names; fall back to a form-level error banner.

## Submission pattern

```typescript
const onSubmit = async (data: FormValues) => {
  try {
    await mutation.mutateAsync(data);
    // success: navigate or show toast
  } catch (error) {
    // map server error to form fields
    mapServerErrorToFields(error, form.setError);
  }
};
```

## Disabled states

- Disable the submit button while `mutation.isPending`.
- Never disable the entire form — only the submit trigger.
- Show a loading indicator on the button, not a spinner overlay.

## NEVER

- Use uncontrolled inputs (no `ref`-only forms).
- Validate only on submit — users need feedback before they commit.
- Map ALL server errors to a generic "Something went wrong" — try to be specific.
