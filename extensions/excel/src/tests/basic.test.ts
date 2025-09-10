// Basic test to verify Jest setup is working
describe('Basic Test Setup', () => {
  test('should have Office.js mocked', () => {
    expect(global.Office).toBeDefined();
    expect(global.Office.onReady).toBeDefined();
    expect(global.Office.HostType).toBeDefined();
  });

  test('should have Excel.js mocked', () => {
    expect(global.Excel).toBeDefined();
    expect(global.Excel.run).toBeDefined();
  });

  test('should have DOM environment', () => {
    expect(document).toBeDefined();
    expect(window).toBeDefined();
  });

  test('should be able to create DOM elements', () => {
    const div = document.createElement('div');
    div.id = 'test-element';
    div.textContent = 'Test';
    document.body.appendChild(div);
    
    const element = document.getElementById('test-element');
    expect(element).toBeTruthy();
    expect(element?.textContent).toBe('Test');
  });

  test('should handle async operations', async () => {
    const result = await Promise.resolve('test');
    expect(result).toBe('test');
  });
}); 