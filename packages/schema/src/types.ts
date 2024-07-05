/**
 * Email address, case-insensitive, and based on the HTML5 spec
 */
export type Email = string & { __brand: "Email" };
