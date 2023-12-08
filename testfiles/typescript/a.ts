/* eslint-disable @typescript-eslint/no-explicit-any */
export function groupBy<T extends Array<any>>(inputArray: T, property: keyof T[number]) {
    const groupedObject = inputArray.reduce((storage, item) => {
      const group = item[property];
      storage[group] = storage[group] || [];
      storage[group].push(item);
      return storage;
    }, {});
  
    return Object.values(groupedObject) as T[];
  }
