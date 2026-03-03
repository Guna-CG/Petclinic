// spec: specs/petclinic-comprehensive-test-plan.md
// seed: tests/seed.spec.ts

import { test, expect } from '@playwright/test';

test.describe('Navigation and Homepage', () => {
  test('Homepage Load and Navigation', async ({ page }) => {
    // 1. Navigate to the application homepage
    await page.goto('http://localhost:8081');
    
    // Verify homepage loads successfully
    await expect(page).toHaveTitle('PetClinic :: a Spring Framework demonstration');
    
    // Verify Welcome message is displayed
    await expect(page.getByRole('heading', { name: 'Welcome' })).toBeVisible();
    
    // 2. Verify main navigation menu items
    await expect(page.getByRole('link', { name: ' Home' })).toBeVisible();
    await expect(page.getByRole('link', { name: ' Find Owners' })).toBeVisible();
    await expect(page.getByRole('link', { name: ' Veterinarians' })).toBeVisible();
    
    // 3. Verify all navigation links are clickable
    await page.getByRole('link', { name: ' Home' }).click();
    
    // Verify we're still on homepage after clicking Home
    await expect(page).toHaveURL('http://localhost:8081/');
    await expect(page.getByRole('heading', { name: 'Welcome' })).toBeVisible();
  });
});