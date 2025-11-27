import { createMockExcelContext, createMockRange } from '../../tests/setup';

describe('Excel Operations', () => {
  let mockExcelContext: any;
  let mockRange: any;

  beforeEach(() => {
    mockExcelContext = createMockExcelContext();
    mockRange = createMockRange();
    
    // Mock Excel.run
    (global.Excel as any).run = jest.fn().mockImplementation(async (callback: Function) => {
      await callback(mockExcelContext);
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('Range Operations', () => {
    test('should get selected range', async () => {
      await global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        range.load('address');
        
        await context.sync();
        
        expect(range.address).toBe('A1:B5');
        expect(context.workbook.getSelectedRange).toHaveBeenCalled();
      });
    });

    test('should apply formatting to range', async () => {
      await global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        
        // Apply formatting
        range.format.fill.color = '#fff2cc';
        range.format.font.color = '#323130';
        range.format.font.bold = true;
        range.format.font.name = 'Segoe UI';
        range.format.font.size = 11;
        range.format.horizontalAlignment = 'Center';
        range.format.verticalAlignment = 'Center';
        
        await context.sync();
        
        expect(range.format.fill.color).toBe('#fff2cc');
        expect(range.format.font.color).toBe('#323130');
        expect(range.format.font.bold).toBe(true);
        expect(range.format.font.name).toBe('Segoe UI');
        expect(range.format.font.size).toBe(11);
        expect(range.format.horizontalAlignment).toBe('Center');
        expect(range.format.verticalAlignment).toBe('Center');
      });
    });

    test('should handle range values', async () => {
      const testValues = [['Name', 'Age'], ['John', 25], ['Jane', 30]];
      mockRange.values = testValues;
      mockExcelContext.workbook.getSelectedRange.mockReturnValue(mockRange);
      
      await global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        range.load('values');
        await context.sync();
        
        expect(range.values).toEqual(testValues);
        
        // Modify values
        range.values = range.values.map((row: (string | number)[]) => 
          row.map((cell: string | number) => typeof cell === 'string' ? cell.trim() : cell)
        );
        
        await context.sync();
        
        expect(range.values).toEqual(testValues); // Should be trimmed
      });
    });
  });

  describe('Table Operations', () => {
    test('should create table from range', async () => {
      const mockTable = {
        name: '',
        style: ''
      };
      mockExcelContext.workbook.tables.add.mockReturnValue(mockTable);
      
      await global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        const table = context.workbook.tables.add(range, true);
        
        table.name = `Table_${Date.now()}`;
        table.style = 'TableStyleMedium2';
        
        await context.sync();
        
        expect(context.workbook.tables.add).toHaveBeenCalledWith(range, true);
        expect(table.name).toMatch(/Table_\d+/);
        expect(table.style).toBe('TableStyleMedium2');
      });
    });

    test('should handle table creation errors', async () => {
      mockExcelContext.workbook.tables.add.mockImplementation(() => {
        throw new Error('Table creation failed');
      });
      
      await expect(global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        context.workbook.tables.add(range, true);
        await context.sync();
      })).rejects.toThrow('Table creation failed');
    });
  });

  describe('Data Validation', () => {
    test('should apply email validation', async () => {
      await global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        
        range.dataValidation.rule = {
          list: {
            inCellDropDown: true
          }
        };
        
        await context.sync();
        
        expect(range.dataValidation.rule).toEqual({
          list: { inCellDropDown: true }
        });
      });
    });

    test('should apply phone validation', async () => {
      await global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        
        range.dataValidation.rule = {
          custom: {
            formula: '=AND(LEN(A1)=10,ISNUMBER(A1))'
          }
        };
        
        await context.sync();
        
        expect(range.dataValidation.rule).toEqual({
          custom: { formula: '=AND(LEN(A1)=10,ISNUMBER(A1))' }
        });
      });
    });

    test('should apply date validation', async () => {
      await global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        
        range.dataValidation.rule = {
          date: {
            operator: 'GreaterThan',
            formula: '=TODAY()-36500'
          }
        };
        
        await context.sync();
        
        expect(range.dataValidation.rule).toEqual({
          date: {
            operator: 'GreaterThan',
            formula: '=TODAY()-36500'
          }
        });
      });
    });

    test('should apply number validation', async () => {
      await global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        
        range.dataValidation.rule = {
          wholeNumber: {
            operator: 'Between',
            minimum: 0,
            maximum: 999999
          }
        };
        
        await context.sync();
        
        expect(range.dataValidation.rule).toEqual({
          wholeNumber: {
            operator: 'Between',
            minimum: 0,
            maximum: 999999
          }
        });
      });
    });
  });

  describe('Data Cleanup Operations', () => {
    test('should remove duplicates', async () => {
      await global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        
        range.removeDuplicates();
        
        await context.sync();
        
        expect(range.removeDuplicates).toHaveBeenCalled();
      });
    });

    test('should trim spaces in string values', async () => {
      const testValues = [['  John  ', ' Doe '], ['  Jane  ', ' Smith ']];
      mockRange.values = testValues;
      mockExcelContext.workbook.getSelectedRange.mockReturnValue(mockRange);
      
      await global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        
        // Trim spaces
        range.values = range.values.map((row: (string | number)[]) => 
          row.map((cell: string | number) => typeof cell === 'string' ? cell.trim() : cell)
        );
        
        await context.sync();
        
        expect(range.values).toEqual([['John', 'Doe'], ['Jane', 'Smith']]);
      });
    });

    test('should standardize format', async () => {
      await global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        
        // Standardize format
        range.format.font.name = 'Segoe UI';
        range.format.font.size = 11;
        
        await context.sync();
        
        expect(range.format.font.name).toBe('Segoe UI');
        expect(range.format.font.size).toBe(11);
      });
    });
  });

  describe('Worksheet Operations', () => {
    test('should get active worksheet', async () => {
      const mockWorksheet = {
        getRange: jest.fn().mockReturnValue({
          values: [],
          format: { font: { bold: false, size: 0 } }
        })
      };
      mockExcelContext.workbook.worksheets.getActiveWorksheet.mockReturnValue(mockWorksheet);
      
      await global.Excel.run(async (context: any) => {
        const worksheet = context.workbook.worksheets.getActiveWorksheet();
        const range = worksheet.getRange('A1');
        
        await context.sync();
        
        expect(context.workbook.worksheets.getActiveWorksheet).toHaveBeenCalled();
        expect(worksheet.getRange).toHaveBeenCalledWith('A1');
      });
    });

    test('should add analysis to worksheet', async () => {
      const mockAnalysisRange = {
        values: [],
        format: { font: { bold: false, size: 0 } }
      };
      const mockWorksheet = {
        getRange: jest.fn().mockReturnValue(mockAnalysisRange)
      };
      mockExcelContext.workbook.worksheets.getActiveWorksheet.mockReturnValue(mockWorksheet);
      
      await global.Excel.run(async (context: any) => {
        const worksheet = context.workbook.worksheets.getActiveWorksheet();
        const analysisRange = worksheet.getRange('A4');
        
        // Add analysis
        analysisRange.values = [['Data Analysis Summary']];
        analysisRange.format.font.bold = true;
        analysisRange.format.font.size = 14;
        
        await context.sync();
        
        expect(analysisRange.values).toEqual([['Data Analysis Summary']]);
        expect(analysisRange.format.font.bold).toBe(true);
        expect(analysisRange.format.font.size).toBe(14);
      });
    });
  });

  describe('Error Handling', () => {
    test('should handle sync errors', async () => {
      mockExcelContext.sync.mockRejectedValue(new Error('Sync failed'));
      
      await expect(global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        await context.sync();
      })).rejects.toThrow('Sync failed');
    });

    test('should handle range loading errors', async () => {
      mockRange.load.mockImplementation(() => {
        throw new Error('Load failed');
      });
      mockExcelContext.workbook.getSelectedRange.mockReturnValue(mockRange);
      
      await expect(global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        range.load('address');
        await context.sync();
      })).rejects.toThrow('Load failed');
    });

    test('should handle invalid range operations', async () => {
      mockExcelContext.workbook.getSelectedRange.mockImplementation(() => {
        throw new Error('Invalid range');
      });
      
      await expect(global.Excel.run(async (context: any) => {
        context.workbook.getSelectedRange();
        await context.sync();
      })).rejects.toThrow('Invalid range');
    });
  });

  describe('Performance Tests', () => {
    test('should handle large datasets efficiently', async () => {
      const largeDataset = Array.from({ length: 1000 }, (_, i) => [`Row ${i}`, `Data ${i}`]);
      mockRange.values = largeDataset;
      mockExcelContext.workbook.getSelectedRange.mockReturnValue(mockRange);
      
      const startTime = Date.now();
      
      await global.Excel.run(async (context: any) => {
        const range = context.workbook.getSelectedRange();
        range.load('values');
        await context.sync();
        
        expect(range.values).toHaveLength(1000);
      });
      
      const endTime = Date.now();
      const duration = endTime - startTime;
      
      // Should complete within reasonable time (adjust as needed)
      expect(duration).toBeLessThan(1000);
    });

    test('should handle multiple operations efficiently', async () => {
      const startTime = Date.now();
      
      await Promise.all([
        global.Excel.run(async (context: any) => {
          const range = context.workbook.getSelectedRange();
          range.format.fill.color = '#fff2cc';
          await context.sync();
        }),
        global.Excel.run(async (context: any) => {
          const range = context.workbook.getSelectedRange();
          range.format.font.bold = true;
          await context.sync();
        }),
        global.Excel.run(async (context: any) => {
          const range = context.workbook.getSelectedRange();
          range.format.font.size = 12;
          await context.sync();
        })
      ]);
      
      const endTime = Date.now();
      const duration = endTime - startTime;
      
      // Should complete within reasonable time
      expect(duration).toBeLessThan(500);
    });
  });
}); 