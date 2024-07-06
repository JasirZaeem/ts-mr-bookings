/**
 * Case-insensitive text.
 */
export type Citext = string & { __brand: "Citext" };

/**
 * Email address, case-insensitive, and based on the HTML5 spec
 */
export type Email = Citext & { __brand: "Email" };
