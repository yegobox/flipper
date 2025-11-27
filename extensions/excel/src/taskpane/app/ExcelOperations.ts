import { RecentActionsManager } from './RecentActionsManager';
import { UiManager } from './UiManager';

export class ExcelOperations {
    constructor(private readonly recentActions: RecentActionsManager, private readonly uiManager: UiManager) {}

    async highlightSelection(): Promise<void> {
        try {
            await Excel.run(async (context) => {
                const range = context.workbook.getSelectedRange();
                range.load('address');

                range.format.fill.color = '#fff2cc';
                range.format.font.color = '#323130';
                range.format.font.bold = true;

                await context.sync();

                this.recentActions.add('Highlight Selection', `Highlighted range ${range.address}`);
                console.log(`Highlighted range: ${range.address}`);
            });
        } catch (error) {
            console.error('Error highlighting selection:', error);
            this.uiManager.showNotification('Failed to highlight selection. Please try again.', 'error');
        }
    }

    async createTable(): Promise<void> {
        try {
            await Excel.run(async (context) => {
                const range = context.workbook.getSelectedRange();
                range.load('address');

                const table = context.workbook.tables.add(range, true);
                table.name = `Table_${Date.now()}`;
                table.style = 'TableStyleMedium2';

                await context.sync();

                this.recentActions.add('Create Table', `Created table from range ${range.address}`);
                console.log(`Created table from range: ${range.address}`);
            });
        } catch (error) {
            console.error('Error creating table:', error);
            this.uiManager.showNotification('Failed to create table. Please try again.', 'error');
        }
    }

    async formatData(): Promise<void> {
        try {
            await Excel.run(async (context) => {
                const range = context.workbook.getSelectedRange();
                range.load('address');

                range.format.font.name = 'Segoe UI';
                range.format.font.size = 11;
                range.format.horizontalAlignment = 'Center';
                range.format.verticalAlignment = 'Center';

                await context.sync();

                this.recentActions.add('Format Data', `Applied formatting to range ${range.address}`);
                console.log(`Formatted range: ${range.address}`);
            });
        } catch (error) {
            console.error('Error formatting data:', error);
            this.uiManager.showNotification('Failed to format data. Please try again.', 'error');
        }
    }

    async analyzeData(): Promise<void> {
        try {
            await Excel.run(async (context) => {
                const range = context.workbook.getSelectedRange();
                range.load('address, rowCount, rowIndex');
                await context.sync();

                const worksheet = context.workbook.worksheets.getActiveWorksheet();
                const analysisRange = worksheet.getRange(`A${range.rowIndex + range.rowCount + 2}`);

                analysisRange.values = [['Data Analysis Summary']];
                analysisRange.format.font.bold = true;
                analysisRange.format.font.size = 14;

                await context.sync();

                this.recentActions.add('Analyze Data', `Analyzed data in range ${range.address}`);
                console.log(`Analyzed data in range: ${range.address}`);
            });
        } catch (error) {
            console.error('Error analyzing data:', error);
            this.uiManager.showNotification('Failed to analyze data. Please try again.', 'error');
        }
    }

    async applyDataValidation(): Promise<void> {
        try {
            const validationType = (document.getElementById('data-validation') as HTMLSelectElement | null)?.value;

            if (!validationType) {
                this.uiManager.showNotification('Please select a validation type', 'warning');
                return;
            }

            await Excel.run(async (context) => {
                const range = context.workbook.getSelectedRange();
                range.load('address');

                switch (validationType) {
                    case 'email':
                        range.dataValidation.rule = {
                            custom: {
                                formula: '=AND(ISNUMBER(FIND("@",INDIRECT("RC",FALSE))),LEN(INDIRECT("RC",FALSE))-LEN(SUBSTITUTE(INDIRECT("RC",FALSE),"@",""))=1,FIND(".",INDIRECT("RC",FALSE))>FIND("@",INDIRECT("RC",FALSE))+1,LEN(LEFT(INDIRECT("RC",FALSE),FIND("@",INDIRECT("RC",FALSE))-1))>0,LEN(MID(INDIRECT("RC",FALSE),FIND("@",INDIRECT("RC",FALSE))+1,LEN(INDIRECT("RC",FALSE))))>2)'
                            }
                        };
                        break;
                    case 'phone':
                        range.dataValidation.rule = {
                            custom: {
                                formula: '=AND(LEN(INDIRECT("RC",FALSE))=10,ISNUMBER(INDIRECT("RC",FALSE)))'
                            }
                        };
                        break;
                    case 'date':
                        range.dataValidation.rule = {
                            date: {
                                operator: 'GreaterThan',
                                formula1: '=TODAY()-365'
                            }
                        };
                        break;
                    case 'number':
                        range.dataValidation.rule = {
                            wholeNumber: {
                                operator: 'Between',
                                formula1: '0',
                                formula2: '100'
                            }
                        };
                        break;
                    default:
                        break;
                }

                await context.sync();

                this.recentActions.add('Apply Validation', `Applied ${validationType} validation to range ${range.address}`);
                console.log(`Applied ${validationType} validation to range: ${range.address}`);
                this.uiManager.showNotification(`Applied ${validationType} validation successfully`, 'success');
            });
        } catch (error) {
            console.error('Error applying data validation:', error);
            this.uiManager.showNotification('Failed to apply data validation. Please try again.', 'error');
        }
    }

    async applyDataCleanup(): Promise<void> {
        try {
            const cleanupType = (document.getElementById('data-cleanup') as HTMLSelectElement | null)?.value;

            if (!cleanupType) {
                this.uiManager.showNotification('Please select a cleanup type', 'warning');
                return;
            }

            await Excel.run(async (context) => {
                const range = context.workbook.getSelectedRange();
                range.load('address, values, columnCount, rowCount');

                await context.sync();

                let changesMade = false;

                switch (cleanupType) {
                    case 'duplicates': {
                        const columns = Array.from({ length: range.columnCount }, (_, i) => i);
                        // Assume header if more than 1 row, otherwise treat single row as data
                        range.removeDuplicates(columns, range.rowCount > 1);
                        changesMade = true;
                        break;
                    }
                    case 'spaces':
                        range.values = range.values.map(row => 
                            row.map(cell => typeof cell === 'string' ? cell.trim() : cell)
                        );
                        changesMade = true;
                        break;
                    case 'format':
                        range.numberFormat = Array.from({ length: range.rowCount }, () => Array(range.columnCount).fill('General'));
                        changesMade = true;
                        break;
                    default:
                        break;
                }

                if (changesMade) {
                    await context.sync();
                    this.recentActions.add('Apply Cleanup', `Applied ${cleanupType} cleanup to range ${range.address}`);
                    console.log(`Applied ${cleanupType} cleanup to range: ${range.address}`);
                    this.uiManager.showNotification(`Applied ${cleanupType} cleanup successfully`, 'success');
                }
            });
        } catch (error) {
            console.error('Error applying data cleanup:', error);
            this.uiManager.showNotification('Failed to apply data cleanup. Please try again.', 'error');
        }
    }
}

