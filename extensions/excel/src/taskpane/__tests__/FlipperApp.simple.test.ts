import { FlipperApp } from '../taskpane';

describe('FlipperApp - Simple Tests', () => {
  let app: FlipperApp;

  beforeEach(() => {
    // Mock Office.onReady to resolve immediately
    (global.Office as any).onReady = jest.fn().mockImplementation((callback: Function) => {
      callback({ host: global.Office.HostType.Excel });
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
    document.body.innerHTML = '';
  });

  test('should create FlipperApp instance', () => {
    // Create a minimal DOM structure
    document.body.innerHTML = `
      <div id="loading-state"></div>
      <div id="app-container"></div>
      <div id="error-state"></div>
    `;
    
    app = new FlipperApp();
    expect(app).toBeDefined();
  });

  test('should have Office.js mocked correctly', () => {
    expect(global.Office).toBeDefined();
    expect(global.Office.HostType.Excel).toBe('Excel');
  });

  test('should have Excel.js mocked correctly', () => {
    expect(global.Excel).toBeDefined();
    expect(global.Excel.run).toBeDefined();
  });
}); 