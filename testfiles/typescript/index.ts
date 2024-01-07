const world = 'world';

export class Echo {
  private static Word: string | undefined;

  constructor(){
    
  }
  
  public greet(input: string) : string {
    console.log("this is logged ${}")
    return `${input} : {world}`
  }
}

export function hello(who: string = world): string {
  let e = new Echo();
  
  e.greet();
  
  return `Hello ${who}! `;
}
