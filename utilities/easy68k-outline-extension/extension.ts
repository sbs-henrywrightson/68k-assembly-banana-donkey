import * as vscode from "vscode";

export function activate(context: vscode.ExtensionContext) {
  const provider: vscode.DocumentSymbolProvider = {
    provideDocumentSymbols(
      document: vscode.TextDocument,
    ): vscode.DocumentSymbol[] {
      const symbols: vscode.DocumentSymbol[] = [];
      let currentSymbol: vscode.DocumentSymbol | undefined;

      for (let line = 0; line < document.lineCount; line++) {
        const text = document.lineAt(line).text;

        const match = text.match(/^\s*(\.?[A-Za-z_][A-Za-z0-9_]*):/);

        if (!match || match.index === undefined) {
          continue;
        }

        const name = match[1];
        const range = new vscode.Range(line, 0, line, text.length);

        const symbol = new vscode.DocumentSymbol(
          name,
          "",
          name.startsWith(".")
            ? vscode.SymbolKind.Method
            : vscode.SymbolKind.Function,
          range,
          new vscode.Range(line, match.index, line, match.index + name.length),
        );

        if (name.startsWith(".") && currentSymbol) {
          currentSymbol.children.push(symbol);
        } else {
          symbols.push(symbol);

          if (!name.startsWith(".")) {
            currentSymbol = symbol;
          }
        }
      }

      return symbols;
    },
  };

  context.subscriptions.push(
    vscode.languages.registerDocumentSymbolProvider(
      { language: "easy68k" },
      provider,
    ),
  );
}

export function deactivate() {}
