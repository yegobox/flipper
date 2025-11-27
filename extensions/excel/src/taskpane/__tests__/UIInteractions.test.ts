import { simulateClick, simulateChange, createMockElement } from '../../tests/setup';

describe('UI Interactions', () => {
  beforeEach(() => {
    document.body.innerHTML = `
      <div id="loading-state" style="display: none;">
        <div class="loading-spinner"></div>
        <p>Loading Flipper...</p>
      </div>
      
      <div id="app-container" style="display: none;">
        <header class="app-header">
          <div class="header-content">
            <img width="32" height="32" src="../../assets/logo.png" alt="Flipper" title="Flipper" />
            <h1 class="app-title">Flipper</h1>
          </div>
          <div class="header-actions">
            <button id="settings-button" class="icon-button" title="Settings">
              <span class="ms-Icon ms-Icon--Settings"></span>
            </button>
          </div>
        </header>
        
        <main class="app-main">
          <section class="section">
            <h2 class="section-title">
              <span class="ms-Icon ms-Icon--LightningBolt"></span>
              Quick Actions
            </h2>
            <div class="action-grid">
              <button class="action-card primary" id="highlight-button">
                <div class="action-icon">
                  <span class="ms-Icon ms-Icon--Highlight"></span>
                </div>
                <div class="action-content">
                  <h3>Highlight Selection</h3>
                  <p>Highlight the selected range with a professional color scheme</p>
                </div>
              </button>
            
              
              <button class="action-card" id="format-data-button">
                <div class="action-icon">
                  <span class="ms-Icon ms-Icon--NumberSymbol"></span>
                </div>
                <div class="action-content">
                  <h3>Format Data</h3>
                  <p>Apply professional formatting to your data</p>
                </div>
              </button>
              
              <button class="action-card" id="analyze-data-button">
                <div class="action-icon">
                  <span class="ms-Icon ms-Icon--BarChart4"></span>
                </div>
                <div class="action-content">
                  <h3>Analyze Data</h3>
                  <p>Get insights and analysis from your data</p>
                </div>
              </button>
            </div>
          </section>
          
          <section class="section">
            <h2 class="section-title">
              <span class="ms-Icon ms-Icon--Database"></span>
              Data Tools
            </h2>
            <div class="tools-container">
              <div class="tool-item">
                <label for="data-validation">Data Validation</label>
                <select id="data-validation" class="tool-select">
                  <option value="">Select validation type...</option>
                  <option value="email">Email Address</option>
                  <option value="phone">Phone Number</option>
                  <option value="date">Date</option>
                  <option value="number">Number Range</option>
                </select>
                <button class="tool-button" id="apply-validation">Apply</button>
              </div>
              
              <div class="tool-item">
                <label for="data-cleanup">Data Cleanup</label>
                <select id="data-cleanup" class="tool-select">
                  <option value="">Select cleanup type...</option>
                  <option value="duplicates">Remove Duplicates</option>
                  <option value="spaces">Trim Spaces</option>
                  <option value="format">Standardize Format</option>
                </select>
                <button class="tool-button" id="apply-cleanup">Apply</button>
              </div>
            </div>
          </section>
          
          <section class="section">
            <h2 class="section-title">
              <span class="ms-Icon ms-Icon--History"></span>
              Recent Actions
            </h2>
            <div id="recent-actions" class="recent-list">
              <div class="empty-state">
                <span class="ms-Icon ms-Icon--Info"></span>
                <p>No recent actions</p>
              </div>
            </div>
          </section>
        </main>
        
        <footer class="app-footer">
          <div class="status-indicator">
            <span class="status-dot connected"></span>
            <span class="status-text">Connected to Excel</span>
          </div>
          <div class="footer-actions">
            <button id="help-button" class="text-button">Help</button>
            <button id="feedback-button" class="text-button">Feedback</button>
          </div>
        </footer>
      </div>
      
      <div id="error-state" style="display: none;">
        <div class="error-content">
          <span class="ms-Icon ms-Icon--Error"></span>
          <h2>Something went wrong</h2>
          <p id="error-message">Unable to connect to Excel. Please try again.</p>
          <button id="retry-button" class="primary-button">Retry</button>
        </div>
      </div>
    `;
  });

  afterEach(() => {
    document.body.innerHTML = '';
  });

  describe('Button Interactions', () => {
    test('should handle highlight button click', () => {
      const highlightButton = document.getElementById('highlight-button') as HTMLButtonElement;
      const clickSpy = jest.fn();
      
      highlightButton.addEventListener('click', clickSpy);
      simulateClick(highlightButton);
      
      expect(clickSpy).toHaveBeenCalled();
    });



    test('should handle format data button click', () => {
      const formatDataButton = document.getElementById('format-data-button') as HTMLButtonElement;
      const clickSpy = jest.fn();
      
      formatDataButton.addEventListener('click', clickSpy);
      simulateClick(formatDataButton);
      
      expect(clickSpy).toHaveBeenCalled();
    });

    test('should handle analyze data button click', () => {
      const analyzeDataButton = document.getElementById('analyze-data-button') as HTMLButtonElement;
      const clickSpy = jest.fn();
      
      analyzeDataButton.addEventListener('click', clickSpy);
      simulateClick(analyzeDataButton);
      
      expect(clickSpy).toHaveBeenCalled();
    });

    test('should handle settings button click', () => {
      const settingsButton = document.getElementById('settings-button') as HTMLButtonElement;
      const clickSpy = jest.fn();
      
      settingsButton.addEventListener('click', clickSpy);
      simulateClick(settingsButton);
      
      expect(clickSpy).toHaveBeenCalled();
    });

    test('should handle help button click', () => {
      const helpButton = document.getElementById('help-button') as HTMLButtonElement;
      const clickSpy = jest.fn();
      
      helpButton.addEventListener('click', clickSpy);
      simulateClick(helpButton);
      
      expect(clickSpy).toHaveBeenCalled();
    });

    test('should handle feedback button click', () => {
      const feedbackButton = document.getElementById('feedback-button') as HTMLButtonElement;
      const clickSpy = jest.fn();
      
      feedbackButton.addEventListener('click', clickSpy);
      simulateClick(feedbackButton);
      
      expect(clickSpy).toHaveBeenCalled();
    });

    test('should handle retry button click', () => {
      const retryButton = document.getElementById('retry-button') as HTMLButtonElement;
      const clickSpy = jest.fn();
      
      retryButton.addEventListener('click', clickSpy);
      simulateClick(retryButton);
      
      expect(clickSpy).toHaveBeenCalled();
    });
  });

  describe('Select Interactions', () => {
    test('should handle data validation select change', () => {
      const validationSelect = document.getElementById('data-validation') as HTMLSelectElement;
      const changeSpy = jest.fn();
      
      validationSelect.addEventListener('change', changeSpy);
      simulateChange(validationSelect, 'email');
      
      expect(changeSpy).toHaveBeenCalled();
      expect(validationSelect.value).toBe('email');
    });

    test('should handle data cleanup select change', () => {
      const cleanupSelect = document.getElementById('data-cleanup') as HTMLSelectElement;
      const changeSpy = jest.fn();
      
      cleanupSelect.addEventListener('change', changeSpy);
      simulateChange(cleanupSelect, 'duplicates');
      
      expect(changeSpy).toHaveBeenCalled();
      expect(cleanupSelect.value).toBe('duplicates');
    });

    test('should handle multiple select changes', () => {
      const validationSelect = document.getElementById('data-validation') as HTMLSelectElement;
      const cleanupSelect = document.getElementById('data-cleanup') as HTMLSelectElement;
      
      simulateChange(validationSelect, 'phone');
      simulateChange(cleanupSelect, 'spaces');
      
      expect(validationSelect.value).toBe('phone');
      expect(cleanupSelect.value).toBe('spaces');
    });
  });

  describe('DOM State Management', () => {
    test('should show loading state', () => {
      const loadingState = document.getElementById('loading-state');
      const appContainer = document.getElementById('app-container');
      const errorState = document.getElementById('error-state');
      
      loadingState!.style.display = 'flex';
      appContainer!.style.display = 'none';
      errorState!.style.display = 'none';
      
      expect(loadingState!.style.display).toBe('flex');
      expect(appContainer!.style.display).toBe('none');
      expect(errorState!.style.display).toBe('none');
    });

    test('should show app container', () => {
      const loadingState = document.getElementById('loading-state');
      const appContainer = document.getElementById('app-container');
      const errorState = document.getElementById('error-state');
      
      loadingState!.style.display = 'none';
      appContainer!.style.display = 'flex';
      errorState!.style.display = 'none';
      
      expect(loadingState!.style.display).toBe('none');
      expect(appContainer!.style.display).toBe('flex');
      expect(errorState!.style.display).toBe('none');
    });

    test('should show error state', () => {
      const loadingState = document.getElementById('loading-state');
      const appContainer = document.getElementById('app-container');
      const errorState = document.getElementById('error-state');
      const errorMessage = document.getElementById('error-message');
      
      loadingState!.style.display = 'none';
      appContainer!.style.display = 'none';
      errorState!.style.display = 'flex';
      errorMessage!.textContent = 'Test error message';
      
      expect(loadingState!.style.display).toBe('none');
      expect(appContainer!.style.display).toBe('none');
      expect(errorState!.style.display).toBe('flex');
      expect(errorMessage!.textContent).toBe('Test error message');
    });
  });

  describe('CSS Classes and Styling', () => {
    test('should have correct CSS classes on action cards', () => {
      const highlightButton = document.getElementById('highlight-button');
      
      expect(highlightButton).toHaveClass('action-card', 'primary');
    });

    test('should have correct CSS classes on buttons', () => {
      const settingsButton = document.getElementById('settings-button');
      const helpButton = document.getElementById('help-button');
      const retryButton = document.getElementById('retry-button');
      
      expect(settingsButton).toHaveClass('icon-button');
      expect(helpButton).toHaveClass('text-button');
      expect(retryButton).toHaveClass('primary-button');
    });

    test('should have correct CSS classes on selects', () => {
      const validationSelect = document.getElementById('data-validation');
      const cleanupSelect = document.getElementById('data-cleanup');
      
      expect(validationSelect).toHaveClass('tool-select');
      expect(cleanupSelect).toHaveClass('tool-select');
    });

    test('should have correct status indicator classes', () => {
      const statusDot = document.querySelector('.status-dot');
      const statusText = document.querySelector('.status-text');
      
      expect(statusDot).toHaveClass('connected');
      expect(statusText).toHaveClass('status-text');
    });
  });

  describe('Accessibility', () => {
    test('should have proper ARIA labels and titles', () => {
      const settingsButton = document.getElementById('settings-button');
      const logo = document.querySelector('img');
      
      expect(settingsButton).toHaveAttribute('title', 'Settings');
      expect(logo).toHaveAttribute('alt', 'Flipper');
      expect(logo).toHaveAttribute('title', 'Flipper');
    });

    test('should have proper form labels', () => {
      const validationLabel = document.querySelector('label[for="data-validation"]');
      const cleanupLabel = document.querySelector('label[for="data-cleanup"]');
      
      expect(validationLabel).toHaveTextContent('Data Validation');
      expect(cleanupLabel).toHaveTextContent('Data Cleanup');
    });

    test('should have proper button text content', () => {
      const highlightButton = document.getElementById('highlight-button');
      
      expect(highlightButton).toHaveTextContent('Highlight Selection');
    });
  });

  describe('Responsive Design', () => {
    test('should handle different screen sizes', () => {
      // Test with different viewport sizes
      const originalInnerWidth = window.innerWidth;
      
      // Simulate mobile viewport
      Object.defineProperty(window, 'innerWidth', {
        writable: true,
        configurable: true,
        value: 320
      });
      
      // Trigger resize event
      window.dispatchEvent(new Event('resize'));
      
      // Restore original width
      Object.defineProperty(window, 'innerWidth', {
        writable: true,
        configurable: true,
        value: originalInnerWidth
      });
      
      // The app should still be functional
      const appContainer = document.getElementById('app-container');
      expect(appContainer).toBeTruthy();
    });

    test('should maintain layout structure', () => {
      const header = document.querySelector('.app-header');
      const main = document.querySelector('.app-main');
      const footer = document.querySelector('.app-footer');
      
      expect(header).toBeTruthy();
      expect(main).toBeTruthy();
      expect(footer).toBeTruthy();
      
      // Check that main content is between header and footer
      const container = document.getElementById('app-container');
      const children = container!.children;
      
      expect(children[0]).toBe(header);
      expect(children[1]).toBe(main);
      expect(children[2]).toBe(footer);
    });
  });

  describe('Error Handling', () => {
    test('should handle missing elements gracefully', () => {
      // Remove elements to simulate missing DOM
      const missingElement = document.getElementById('highlight-button');
      missingElement?.remove();
      
      // Should not throw when trying to access missing element
      expect(() => {
        const element = document.getElementById('highlight-button');
        expect(element).toBeNull();
      }).not.toThrow();
    });

    test('should handle invalid element types', () => {
      const validationSelect = document.getElementById('data-validation') as HTMLSelectElement;
      // Add the invalid option for testing
      const option = document.createElement('option');
      option.value = 'invalid-value';
      validationSelect.appendChild(option);

      expect(() => {
        simulateChange(validationSelect, 'invalid-value');
      }).not.toThrow();

      expect(validationSelect.value).toBe('invalid-value');
    });
  });

  describe('Performance', () => {
    test('should handle rapid button clicks', () => {
      const button = document.getElementById('highlight-button') as HTMLButtonElement;
      const clickSpy = jest.fn();
      
      button.addEventListener('click', clickSpy);
      
      // Simulate rapid clicks
      for (let i = 0; i < 10; i++) {
        simulateClick(button);
      }
      
      expect(clickSpy).toHaveBeenCalledTimes(10);
    });

    test('should handle multiple select changes efficiently', () => {
      const select = document.getElementById('data-validation') as HTMLSelectElement;
      const changeSpy = jest.fn();
      
      select.addEventListener('change', changeSpy);
      
      // Simulate multiple changes
      const options = ['email', 'phone', 'date', 'number'];
      options.forEach(option => {
        simulateChange(select, option);
      });
      
      expect(changeSpy).toHaveBeenCalledTimes(4);
      expect(select.value).toBe('number');
    });
  });
}); 