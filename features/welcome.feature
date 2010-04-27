Feature: The welcome page

  As a novice intellectual
  To give me comfort when I first go to this site
  I want a comforting welcome page to great me
  
  Scenario: My first time launching the app is a tautology
    When I go to the welcome page
    Then I should be on the welcome page
    And  I should see "Yogo"
    
