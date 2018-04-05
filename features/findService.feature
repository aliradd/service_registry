Scenario Outline: Find service:
    Given add_Service_Registry is run
    and the following services exist:
      | service | version | change  | uniqueID          |
      | test    | 0.0.1   | created | 0.0.1.1.epochtime |
      | test    | 0.0.1   | created | 0.0.1.2.epochtime |
      | test    | 0.0.2   | created | 0.0.2.1.epochtime |
      | test    | 0.0.2   | created | 0.0.2.2.epochtime |
      | test2   | 0.0.2   | created | 0.0.2.1.epochtime |
      | test2   | 0.0.2   | created | 0.0.2.2.epochtime |

Scenario Outline: Finding all api end points:   
   When call the root directory "/"
   Then I should get a list of all end points <end_points> and call type <call_type>
      | end_points                    | call_type    |
      |service_registry/addService    | POST         |
      |service_registry/findService   | GET          |
      |service_registry/updateService | PUT          |
      |service_registry/deleteService | Delete       |

      
   and the response should be paged
  

Scenario Outline: Finding all services:   
   When I search for a service "<service>" 
   Then I should get a list of all the services :
      | service | version | change  | uniqueID          |
      | test    | 0.0.1   | created | 0.0.1.1.epochtime |
      | test    | 0.0.1   | created | 0.0.1.2.epochtime |
      | test    | 0.0.2   | created | 0.0.2.1.epochtime |
      | test    | 0.0.2   | created | 0.0.2.2.epochtime |
      | test2   | 0.0.2   | created | 0.0.2.1.epochtime |
      | test2   | 0.0.2   | created | 0.0.2.2.epochtime |
   and the response should be paged
   
   
   When I search for a service "<service>" with version "<version>"
    Then I should find count "<count>" instances of service
    And the service "<service>" should have the correct type
    And the service "<service>" should have the correct version "<version>"
    Examples:
      | service | version | count |
      | test    | 0.0.1   |   2   |
      | test    | 0.0.2   |   2   |
      | test2   | 0.0.2   |   2   |

  Scenario Outline: Finding non existing service:
    When I search for a service "<service>" with version "<version>"
    Then I should find count "<count>" services
    Examples:
      | service | version | count |
      | test    | 0.0.4   |   0   |
      | test3   | 0.0.1   |   0   |


  Scenario Outline: Finding service without version:
    When I search for a service "<service>" without version
    Then I should find count "<count>" services
    And the service "<service>" should have the correct type
    Examples:
      | service | count |
      | test    |   4   |
      | test2   |   2   |
   
  Scenario Outline: Finding service unique id

    When I search for a service "<service>" with version "<version>" with number "<number>"
    Then I should find count "<uniqueID>" instances of service
    And the service "<service>" should have the correct type
    And the service "<service>" should have the correct version "<version>"
    Examples:
      | service | version | number| uniqueID |
      | test    | 0.0.1   | 1     | 0.0.1.1.epochtime |
      | test    | 0.0.1   | 2     | 0.0.1.2.epochtime |
      | test    | 0.0.2   | 1     | 0.0.2.1.epochtime |
      | test    | 0.0.2   | 2     | 0.0.2.2.epochtime |
      | test2   | 0.0.2   | 1     | 0.0.2.1.epochtime |
      | test2   | 0.0.2   | 2     | 0.0.2.2.epochtime |

  Scenario Outline: Finding service with non existing number:
    When I search for a service "<service>" with version "<version>" with number "<number>"
    Then I should find count "<count>" services
    Examples:

      | service | version | number| uniqueID          | count  |
      | test    | 0.0.1   | 3     | "No such service" |   0    | 
      | test    | 0.0.1   | b     | "No such service" |   0    |
      | test    | 0.0.2   | 3     | "No such service" |   0    |
      | test    | 0.0.2   | 10    | "No such service" |   0    |
      | test4   | 0.0.2   | 1     | "No such service" |   0    | 
      | test    | 0.0.4   | 1     | "No such service" |   0    |
