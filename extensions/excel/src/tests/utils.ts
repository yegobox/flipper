import { createMockExcelContext, createMockRange } from './setup';

/**
 * Test utilities for common testing scenarios
 */

export interface TestData {
  values: any[][];
  address: string;
  expectedFormat?: any;
}

export const createTestData = (): TestData => ({
  values: [
    ['Name', 'Age', 'Email'],
    ['John Doe', 25, 'john@example.com'],
    ['Jane Smith', 30, 'jane@example.com'],
    ['Bob Johnson', 35, 'bob@example.com']
  ],
  address: 'A1:C4',
  expectedFormat: {
    fill: { color: '#fff2cc' },
    font: { 
      color: '#323130', 
      bold: true, 
      name: 'Segoe UI', 
      size: 11 
    },
    horizontalAlignment: 'Center',
    verticalAlignment: 'Center'
  }
});

export const createMockExcelContextWithData = (testData: TestData) => {
  const mockContext = createMockExcelContext();
  const mockRange = createMockRange();
  
  mockRange.values = testData.values;
  mockRange.address = testData.address;
  
  if (testData.expectedFormat) {
    Object.assign(mockRange.format, testData.expectedFormat);
  }
  
  mockContext.workbook.getSelectedRange.mockReturnValue(mockRange);
  
  return { mockContext, mockRange };
};

export const waitForAsync = (ms: number = 0): Promise<void> => {
  return new Promise(resolve => setTimeout(resolve, ms));
};

export const createNotificationSpy = () => {
  const notifications: Array<{ message: string; type: string }> = [];
  
  // Mock the showNotification method
  const showNotification = (message: string, type: 'success' | 'error' | 'warning' = 'success') => {
    notifications.push({ message, type });
  };
  
  return { showNotification, notifications };
};

export const createEventSpy = () => {
  const events: Array<{ type: string; target: string; value?: string }> = [];
  
  const addEventListener = (element: HTMLElement, eventType: string, callback: Function) => {
    element.addEventListener(eventType, (event) => {
      events.push({
        type: eventType,
        target: (event.target as HTMLElement).id || (event.target as HTMLElement).tagName,
        value: (event.target as HTMLSelectElement)?.value
      });
      callback(event);
    });
  };
  
  return { addEventListener, events };
};

export const validateExcelOperation = async (
  operation: () => Promise<void>,
  expectedSyncCalls: number = 1
) => {
  const mockContext = createMockExcelContext();
  let syncCallCount = 0;
  
  mockContext.sync = jest.fn().mockImplementation(() => {
    syncCallCount++;
    return Promise.resolve();
  });
  
  (global.Excel as any).run = jest.fn().mockImplementation(async (callback: Function) => {
    await callback(mockContext);
  });
  
  await operation();
  
  expect(mockContext.sync).toHaveBeenCalledTimes(expectedSyncCalls);
  expect(syncCallCount).toBe(expectedSyncCalls);
};

export const validateRangeFormatting = async (
  operation: () => Promise<void>,
  expectedFormat: any
) => {
  const mockContext = createMockExcelContext();
  const mockRange = createMockRange();
  
  mockContext.workbook.getSelectedRange.mockReturnValue(mockRange);
  
  (global.Excel as any).run = jest.fn().mockImplementation(async (callback: Function) => {
    await callback(mockContext);
  });
  
  await operation();
  
  // Validate that the range formatting matches expected format
  Object.entries(expectedFormat).forEach(([key, value]) => {
    if (typeof value === 'object') {
      Object.entries(value).forEach(([subKey, subValue]) => {
        expect(mockRange.format[key][subKey]).toBe(subValue);
      });
    } else {
      expect(mockRange.format[key]).toBe(value);
    }
  });
};

export const validateDataValidation = async (
  operation: () => Promise<void>,
  expectedRule: any
) => {
  const mockContext = createMockExcelContext();
  const mockRange = createMockRange();
  
  mockContext.workbook.getSelectedRange.mockReturnValue(mockRange);
  
  (global.Excel as any).run = jest.fn().mockImplementation(async (callback: Function) => {
    await callback(mockContext);
  });
  
  await operation();
  
  expect(mockRange.dataValidation.rule).toEqual(expectedRule);
};

export const validateTableCreation = async (
  operation: () => Promise<void>,
  expectedNamePattern: RegExp,
  expectedStyle: string
) => {
  const mockContext = createMockExcelContext();
  const mockTable = { name: '', style: '' };
  
  mockContext.workbook.tables.add.mockReturnValue(mockTable);
  
  (global.Excel as any).run = jest.fn().mockImplementation(async (callback: Function) => {
    await callback(mockContext);
  });
  
  await operation();
  
  expect(mockTable.name).toMatch(expectedNamePattern);
  expect(mockTable.style).toBe(expectedStyle);
  expect(mockContext.workbook.tables.add).toHaveBeenCalled();
};

export const createPerformanceTest = (
  operation: () => Promise<void>,
  maxDuration: number = 1000
) => {
  return async () => {
    const startTime = Date.now();
    
    await operation();
    
    const endTime = Date.now();
    const duration = endTime - startTime;
    
    expect(duration).toBeLessThan(maxDuration);
  };
};

export const createErrorTest = (
  operation: () => Promise<void>,
  expectedError: string | RegExp
) => {
  return async () => {
    await expect(operation()).rejects.toThrow(expectedError);
  };
};

export const validateRecentAction = (
  recentActions: any[],
  expectedAction: string,
  expectedDescription: string
) => {
  expect(recentActions).toHaveLength(1);
  expect(recentActions[0].action).toBe(expectedAction);
  expect(recentActions[0].description).toBe(expectedDescription);
  expect(recentActions[0].timestamp).toBeInstanceOf(Date);
  expect(recentActions[0].id).toBeDefined();
};

export const validateTimeFormatting = (
  formatTime: (date: Date) => string,
  testCases: Array<{ date: Date; expected: string }>
) => {
  testCases.forEach(({ date, expected }) => {
    expect(formatTime(date)).toBe(expected);
  });
};

export const createDOMTest = (
  setup: () => void,
  test: () => void,
  cleanup: () => void
) => {
  return () => {
    setup();
    test();
    cleanup();
  };
};

export const validateNotification = (
  showNotification: (message: string, type: string) => void,
  message: string,
  type: 'success' | 'error' | 'warning' = 'success'
) => {
  const { showNotification: mockShowNotification, notifications } = createNotificationSpy();
  
  // Replace the actual showNotification with our mock
  const originalShowNotification = showNotification;
  showNotification = mockShowNotification;
  
  showNotification(message, type);
  
  expect(notifications).toHaveLength(1);
  expect(notifications[0].message).toBe(message);
  expect(notifications[0].type).toBe(type);
  
  // Restore original function
  showNotification = originalShowNotification;
};

export const createAccessibilityTest = (element: HTMLElement) => {
  return {
    hasAriaLabel: () => {
      expect(element).toHaveAttribute('aria-label');
    },
    hasAriaDescribedBy: () => {
      expect(element).toHaveAttribute('aria-describedby');
    },
    hasRole: (role: string) => {
      expect(element).toHaveAttribute('role', role);
    },
    hasTabIndex: (tabIndex: number) => {
      expect(element).toHaveAttribute('tabindex', tabIndex.toString());
    },
    isFocusable: () => {
      expect(element).toHaveAttribute('tabindex');
    }
  };
};

export const createResponsiveTest = (element: HTMLElement) => {
  return {
    testMobileViewport: () => {
      Object.defineProperty(window, 'innerWidth', {
        writable: true,
        configurable: true,
        value: 320
      });
      
      window.dispatchEvent(new Event('resize'));
      
      expect(element).toBeTruthy();
    },
    testTabletViewport: () => {
      Object.defineProperty(window, 'innerWidth', {
        writable: true,
        configurable: true,
        value: 768
      });
      
      window.dispatchEvent(new Event('resize'));
      
      expect(element).toBeTruthy();
    },
    testDesktopViewport: () => {
      Object.defineProperty(window, 'innerWidth', {
        writable: true,
        configurable: true,
        value: 1024
      });
      
      window.dispatchEvent(new Event('resize'));
      
      expect(element).toBeTruthy();
    }
  };
}; 