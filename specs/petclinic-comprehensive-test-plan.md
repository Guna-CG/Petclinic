# Spring Petclinic Comprehensive Test Plan

## Application Overview

The Spring Petclinic is a veterinary clinic management system that allows users to manage pet owners, their pets, veterinarians, and veterinary visits. The application provides functionality for owner registration, pet management, visit scheduling, and vet information display. This test plan covers all major user flows including happy paths, edge cases, and error handling scenarios to ensure comprehensive coverage of the application's functionality.

## Test Scenarios

### 1. Navigation and Homepage

**Seed:** `tests/seed.spec.ts`

#### 1.1. Homepage Load and Navigation

**File:** `tests/navigation/homepage.spec.ts`

**Steps:**
  1. Navigate to the application homepage
    - expect: The homepage loads successfully
    - expect: Welcome message is displayed
    - expect: Navigation menu is visible with options for Home, Find owners, Veterinarians
  2. Verify main navigation menu items
    - expect: Home navigation link is present and functional
    - expect: Find owners link is present
    - expect: Veterinarians link is present
    - expect: All navigation links are clickable
  3. Check homepage content and branding
    - expect: Spring Petclinic logo or title is displayed
    - expect: Welcome image with pets is shown
    - expect: Page title contains 'PetClinic' or similar

#### 1.2. Error Page Functionality

**File:** `tests/navigation/error-handling.spec.ts`

**Steps:**
  1. Navigate to '/oups' endpoint to trigger intentional error
    - expect: Error page is displayed
    - expect: Appropriate error message is shown
    - expect: User can navigate back to homepage
  2. Access non-existent page URL
    - expect: 404 error page is displayed
    - expect: Error message indicates page not found
    - expect: Navigation options are still available

### 2. Owner Management

**Seed:** `tests/seed.spec.ts`

#### 2.1. Find Owners - Happy Path

**File:** `tests/owners/find-owners-happy.spec.ts`

**Steps:**
  1. Navigate to 'Find owners' from main menu
    - expect: Find owners page loads
    - expect: Search form is displayed with Last name field
    - expect: Find Owner and Add Owner buttons are visible
  2. Leave search field empty and click 'Find Owner'
    - expect: All owners are displayed in a paginated list
    - expect: Owner names, addresses, city, telephone are shown
    - expect: Each owner row is clickable
  3. Enter partial last name (e.g., 'Da') and search
    - expect: Filtered results showing owners with matching last names
    - expect: Results are displayed in tabular format
    - expect: Pagination controls appear if more than 5 results
  4. Enter exact last name that returns single result
    - expect: User is redirected directly to owner details page
    - expect: Owner information is displayed
    - expect: List of pets is shown if any exist

#### 2.2. Find Owners - Edge Cases

**File:** `tests/owners/find-owners-edge-cases.spec.ts`

**Steps:**
  1. Search for non-existent last name (e.g., 'ZZZZZZ')
    - expect: 'No owners found' message is displayed
    - expect: User remains on search page
    - expect: Can perform new search
  2. Enter special characters in search field
    - expect: System handles special characters gracefully
    - expect: No error occurs
    - expect: Appropriate results or no results message
  3. Test pagination when multiple results exist
    - expect: Navigation between pages works correctly
    - expect: Page numbers are displayed
    - expect: Previous/Next buttons function properly

#### 2.3. Add New Owner - Happy Path

**File:** `tests/owners/add-owner-happy.spec.ts`

**Steps:**
  1. Click 'Add Owner' button from find owners page
    - expect: Owner registration form is displayed
    - expect: Form fields: First Name, Last Name, Address, City, Telephone
    - expect: Add Owner and Back buttons are visible
  2. Fill all required fields with valid data and submit
    - expect: Owner is successfully created
    - expect: Redirected to owner details page
    - expect: Success message is displayed
    - expect: Owner information is correctly displayed
  3. Verify new owner appears in search results
    - expect: Owner can be found through search
    - expect: All entered information is preserved
    - expect: Owner has unique ID assigned

#### 2.4. Add New Owner - Validation and Error Cases

**File:** `tests/owners/add-owner-validation.spec.ts`

**Steps:**
  1. Submit form with empty required fields
    - expect: Validation errors are displayed
    - expect: Form is not submitted
    - expect: Error messages indicate which fields are required
  2. Enter invalid telephone number format
    - expect: Validation message for telephone format
    - expect: Field is highlighted as invalid
    - expect: Form cannot be submitted until corrected
  3. Enter extremely long values in text fields
    - expect: System handles long inputs appropriately
    - expect: Field length limits are enforced
    - expect: Appropriate error messages if limits exceeded
  4. Test field validation on blur/focus
    - expect: Real-time validation feedback
    - expect: Error states clear when corrected
    - expect: Visual indicators for valid/invalid fields

#### 2.5. Edit Owner Information

**File:** `tests/owners/edit-owner.spec.ts`

**Steps:**
  1. Navigate to existing owner details and click Edit
    - expect: Edit form is pre-populated with current data
    - expect: All fields are editable
    - expect: Update Owner and Back buttons are present
  2. Modify owner information and save changes
    - expect: Changes are saved successfully
    - expect: Updated information is displayed
    - expect: Success message confirms update
  3. Cancel edit operation
    - expect: Changes are discarded
    - expect: User returns to owner details
    - expect: Original data is preserved

### 3. Pet Management

**Seed:** `tests/seed.spec.ts`

#### 3.1. Add Pet to Owner - Happy Path

**File:** `tests/pets/add-pet-happy.spec.ts`

**Steps:**
  1. Navigate to owner details page and click 'Add New Pet'
    - expect: Pet registration form is displayed
    - expect: Form fields: Name, Birth Date, Type dropdown
    - expect: Owner information is shown at top
  2. Fill pet information with valid data and submit
    - expect: Pet is successfully added
    - expect: Redirected to owner details page
    - expect: New pet appears in pets list
    - expect: Success message is displayed
  3. Verify pet type dropdown options
    - expect: Multiple pet types are available (dog, cat, bird, etc.)
    - expect: User can select appropriate pet type
    - expect: Selection is saved correctly

#### 3.2. Add Pet - Validation and Edge Cases

**File:** `tests/pets/add-pet-validation.spec.ts`

**Steps:**
  1. Submit pet form with empty required fields
    - expect: Validation errors are displayed
    - expect: Form is not submitted
    - expect: Required field messages are shown
  2. Enter future birth date
    - expect: Validation error for birth date
    - expect: Error message indicates date cannot be in future
    - expect: Form cannot be submitted
  3. Add pet with name that already exists for same owner
    - expect: Duplicate name validation error
    - expect: Error message indicates pet name already exists
    - expect: User must choose different name
  4. Enter extremely long pet name
    - expect: Field length validation
    - expect: Appropriate error message
    - expect: Name is truncated or rejected

#### 3.3. Edit Pet Information

**File:** `tests/pets/edit-pet.spec.ts`

**Steps:**
  1. Navigate to owner details and click Edit for existing pet
    - expect: Edit pet form is displayed
    - expect: Form is pre-populated with current pet data
    - expect: All fields are editable
  2. Update pet information and save changes
    - expect: Changes are saved successfully
    - expect: Updated information is displayed
    - expect: Owner page shows updated pet details
  3. Test validation during pet edit
    - expect: Same validation rules apply as adding pet
    - expect: Cannot create duplicate names
    - expect: Birth date validation enforced

### 4. Visit Management

**Seed:** `tests/seed.spec.ts`

#### 4.1. Add Visit - Happy Path

**File:** `tests/visits/add-visit-happy.spec.ts`

**Steps:**
  1. Navigate to pet details and click 'Add Visit'
    - expect: Visit form is displayed
    - expect: Pet and owner information is shown
    - expect: Form fields: Date, Description
  2. Fill visit information and submit
    - expect: Visit is successfully added
    - expect: Redirected to owner details
    - expect: New visit appears in pet's visit history
    - expect: Success message is displayed
  3. Verify visit appears in chronological order
    - expect: Visits are sorted by date
    - expect: Most recent visits appear first or last consistently
    - expect: Visit details are complete

#### 4.2. Add Visit - Validation

**File:** `tests/visits/add-visit-validation.spec.ts`

**Steps:**
  1. Submit visit form with empty description
    - expect: Validation error for required description
    - expect: Form is not submitted
    - expect: Error message is clear
  2. Enter extremely long description text
    - expect: System handles long descriptions appropriately
    - expect: Text area limits or scrolling
    - expect: No data loss occurs
  3. Test date field validation
    - expect: Date format is enforced
    - expect: Invalid dates are rejected
    - expect: Future dates are handled appropriately

### 5. Veterinarian Information

**Seed:** `tests/seed.spec.ts`

#### 5.1. View Veterinarians List

**File:** `tests/vets/view-vets.spec.ts`

**Steps:**
  1. Navigate to Veterinarians page from main menu
    - expect: Veterinarians list is displayed
    - expect: Vet names and specialties are shown
    - expect: Page has appropriate title
  2. Verify veterinarian information display
    - expect: Each vet shows name and specialties
    - expect: Specialties are clearly listed
    - expect: Professional presentation of information
  3. Test pagination if many veterinarians exist
    - expect: Pagination controls work correctly
    - expect: Page navigation is smooth
    - expect: Vet count information is accurate

#### 5.2. Veterinarian Data Integrity

**File:** `tests/vets/vet-data-integrity.spec.ts`

**Steps:**
  1. Verify all veterinarians have required information
    - expect: No vet entries are missing names
    - expect: Specialty information is present
    - expect: No broken or empty entries
  2. Check veterinarian specialty formatting
    - expect: Specialties are properly formatted
    - expect: Multiple specialties are clearly separated
    - expect: No formatting issues or overlaps

### 6. Cross-Functional and Integration Tests

**Seed:** `tests/seed.spec.ts`

#### 6.1. Complete User Journey

**File:** `tests/integration/complete-user-journey.spec.ts`

**Steps:**
  1. Complete workflow: Add owner, add pet, add visit
    - expect: Each step completes successfully
    - expect: Data persists between operations
    - expect: All relationships are maintained
  2. Navigate through all major sections of application
    - expect: All navigation links work correctly
    - expect: No broken links or errors
    - expect: Consistent user experience
  3. Verify data consistency across different views
    - expect: Owner information is consistent everywhere
    - expect: Pet details match across views
    - expect: Visit information is accurate

#### 6.2. Browser Compatibility and Responsive Design

**File:** `tests/integration/browser-compatibility.spec.ts`

**Steps:**
  1. Test application in different viewport sizes
    - expect: Application is responsive on mobile screens
    - expect: Desktop view is properly formatted
    - expect: Navigation adapts to screen size
  2. Verify form functionality across different screen sizes
    - expect: Forms are usable on small screens
    - expect: Input fields are properly sized
    - expect: Buttons are accessible
  3. Test keyboard navigation and accessibility
    - expect: Tab navigation works properly
    - expect: Form fields are keyboard accessible
    - expect: Appropriate ARIA labels if implemented

#### 6.3. Performance and Load Testing

**File:** `tests/integration/performance.spec.ts`

**Steps:**
  1. Measure page load times for main sections
    - expect: Homepage loads within acceptable time
    - expect: Owner search performs efficiently
    - expect: Large data sets are handled well
  2. Test application with large amounts of data
    - expect: Pagination handles large datasets
    - expect: Search performance remains good
    - expect: No timeout errors occur
  3. Verify memory usage and resource management
    - expect: No memory leaks in extended usage
    - expect: Images and resources load properly
    - expect: Browser performance remains stable
