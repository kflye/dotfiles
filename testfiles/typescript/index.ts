const world = 'world';

export class Echo {
  private static Word: string | undefined;

  constructor() {}

  public greet(input: string): string {
    // no-console (eslint warning) below:
    console.log('this is logged ${}');
    return `${input} : {world}`;
  }
}

export function hello(who: string = world): string {
  // `e` is never reassigned -> prefer-const (auto-fixable eslint code action).
  let e = new Echo();

  // @typescript-eslint/no-unused-vars: `unused` is never used (eslint warning).
  const unused = 42;

  e.greet('hi');

  return `Hello ${who}! `;
}
