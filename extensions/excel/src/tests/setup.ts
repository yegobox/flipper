import '@testing-library/jest-dom';

// Mock Office.js
global.Office = {
  onReady: jest.fn(),
  HostType: {
    Excel: 'Excel'
  }
} as any;

// Mock Excel namespace
global.Excel = {
  run: jest.fn(),
  RequestContext: jest.fn()
} as any;

// Mock console methods to reduce noise in tests
global.console = {
  ...console,
  log: jest.fn(),
  error: jest.fn(),
  warn: jest.fn(),
  info: jest.fn()
};

// Mock DOM methods that might not be available in jsdom
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: jest.fn().mockImplementation(query => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: jest.fn(),
    removeListener: jest.fn(),
    addEventListener: jest.fn(),
    removeEventListener: jest.fn(),
    dispatchEvent: jest.fn(),
  })),
});

// Mock IntersectionObserver
global.IntersectionObserver = jest.fn().mockImplementation(() => ({
  observe: jest.fn(),
  unobserve: jest.fn(),
  disconnect: jest.fn(),
}));

// Mock ResizeObserver
global.ResizeObserver = jest.fn().mockImplementation(() => ({
  observe: jest.fn(),
  unobserve: jest.fn(),
  disconnect: jest.fn(),
}));

// Setup test utilities
export const createMockExcelContext = () => ({
  workbook: {
    getSelectedRange: jest.fn().mockReturnValue({
      load: jest.fn(),
      address: 'A1:B5',
      format: {
        fill: { color: '' },
        font: { color: '', bold: false, name: '', size: 0 },
        horizontalAlignment: '',
        verticalAlignment: ''
      },
      dataValidation: {
        rule: {}
      },
      removeDuplicates: jest.fn(),
      values: [['test', 'data'], ['more', 'data']],
      getRowCount: jest.fn().mockReturnValue(2)
    }),
    tables: {
      add: jest.fn().mockReturnValue({
        name: '',
        style: ''
      })
    },
    worksheets: {
      getActiveWorksheet: jest.fn().mockReturnValue({
        getRange: jest.fn().mockReturnValue({
          values: [],
          format: {
            font: { bold: false, size: 0 }
          }
        })
      })
    }
  },
  sync: jest.fn()
});

export const createMockRange = () => ({
  load: jest.fn(),
  address: 'A1:B5',
  format: {
    fill: { color: '' },
    font: { color: '', bold: false, name: '', size: 0 },
    horizontalAlignment: '',
    verticalAlignment: ''
  },
  dataValidation: {
    rule: {}
  },
  removeDuplicates: jest.fn(),
  values: [['test', 'data'], ['more', 'data']],
  getRowCount: jest.fn().mockReturnValue(2)
});

// Helper function to create a mock DOM element
export const createMockElement = (tagName: string, attributes: Record<string, string> = {}) => {
  const element = document.createElement(tagName);
  Object.entries(attributes).forEach(([key, value]) => {
    element.setAttribute(key, value);
  });
  return element;
};

// Helper function to simulate user interactions
export const simulateClick = (element: HTMLElement) => {
  const event = new MouseEvent('click', {
    bubbles: true,
    cancelable: true,
    view: window
  });
  element.dispatchEvent(event);
};

export const simulateChange = (element: HTMLSelectElement, value: string) => {
  element.value = value;
  const event = new Event('change', { bubbles: true });
  element.dispatchEvent(event);
}; 