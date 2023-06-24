# Typescript Troubleshooting

## UMD module import error

Given this code:

```ts
import jsonc from "jsonc-parser";
const jsoncContent = jsonc.parseTree("{}");
```

It errors when run with:

```
   const jsoncContent = jsonc_parser_1.default.parseTree(fileContent);
                                                ^

TypeError: Cannot read properties of undefined (reading 'parseTree')
```

Because jsonc-parser is a [umd module, import it](https://www.typescriptlang.org/docs/handbook/declaration-files/templates/global-plugin-d-ts.html#from-a-module-or-umd-library) like this:

```ts
import * as jsonc from 'jsonc-parser';
```
