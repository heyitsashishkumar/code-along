/**
 * Turns the errors Salesforce sends back into plain messages a person can read.
 * Accepts one error or a list of them; returns a list of strings.
 */
export function reduceErrors(errors) {
    const list = Array.isArray(errors) ? errors : [errors];
    const messages = [];
    list.filter((error) => error).forEach((error) => {
        const body = error.body;
        if (Array.isArray(body)) {
            body.forEach((item) => messages.push(item.message));
        } else if (body && body.output) {
            body.output.errors.forEach((item) => messages.push(item.message));
            Object.values(body.output.fieldErrors).forEach((fieldErrors) => {
                fieldErrors.forEach((item) => messages.push(item.message));
            });
            if (messages.length === 0) {
                messages.push(body.message);
            }
        } else if (body && body.message) {
            messages.push(body.message);
        } else if (error.message) {
            messages.push(error.message);
        }
    });
    return messages.filter((message) => message);
}
