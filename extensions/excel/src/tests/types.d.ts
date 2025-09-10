// Type declarations for Office.js and Excel.js
declare global {
  namespace Office {
    function onReady(callback: (info: OfficeReadyInfo) => void): void;
    
    namespace HostType {
      const Excel: string;
      const Word: string;
      const PowerPoint: string;
      const Outlook: string;
      const OneNote: string;
      const Project: string;
    }

    // Add-in Commands
    namespace AddinCommands {
      interface Event {
        source: any;
        type: string;
        completed(): void;
      }
    }

    // Notification Messages
    interface NotificationMessageDetails {
      type: string;
      message: string;
      icon?: string;
      persistent?: boolean;
    }

    // Mailbox Enums
    namespace MailboxEnums {
      namespace ItemNotificationMessageType {
        const InformationalMessage: string;
      }
    }

    // Context
    const context: {
      mailbox: {
        item: {
          notificationMessages: {
            replaceAsync(key: string, message: NotificationMessageDetails): Promise<void>;
          };
        };
      };
    };

    // Actions
    const actions: {
      associate(actionName: string, action: (event: AddinCommands.Event) => void): void;
    };
  }

  namespace Excel {
    function run(callback: (context: RequestContext) => Promise<void>): Promise<void>;
    
    interface RequestContext {
      workbook: Workbook;
      sync(): Promise<void>;
    }

    interface Workbook {
      getSelectedRange(): Range;
      tables: TableCollection;
      worksheets: WorksheetCollection;
      context: any;
    }

    interface Range {
      address: string;
      load(option: string): void;
      format: RangeFormat;
      dataValidation: DataValidation;
      values: any[][];
      removeDuplicates(): void;
      getRowCount(): number;
      merge(): void;
      getRange(address: string): Range;
    }

    interface RangeFormat {
      fill: Fill;
      font: Font;
      horizontalAlignment: string;
      verticalAlignment: string;
      borders: Borders;
      autofitColumns(): void;
    }

    interface Fill {
      color: string;
    }

    interface Font {
      color: string;
      bold: boolean;
      name: string;
      size: number;
    }

    interface DataValidation {
      rule: any;
    }

    interface TableCollection {
      add(range: Range, hasHeaders: boolean): Table;
    }

    interface Table {
      name: string;
      style: string;
    }

    interface WorksheetCollection {
      getActiveWorksheet(): Worksheet;
      getItem(name: string): Worksheet;
      add(name?: string): Worksheet;
      load(option: string): void;
      items: Worksheet[];
    }

    interface Worksheet {
      name: string;
      getRange(address: string): Range;
      getUsedRange(): Range;
      activate(): void;
      delete(): void;
    }

    interface Borders {
      getItem(edge: string): Border;
    }

    interface Border {
      style: string;
    }
  }

  interface OfficeReadyInfo {
    host: string;
  }
}

export {}; 