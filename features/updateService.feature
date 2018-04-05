  Scenario Outline: updating a service with service name only:
    Given add_Service_Registry is run
    and the following services exist:
      | service | version | change  | uniqueID          | change_version |
      | test    | 0.0.1   | created | 0.0.1.1.epochtime |      1         |
      | test    | 0.0.1   | created | 0.0.1.2.epochtime |      1         |
      | test    | 0.0.2   | created | 0.0.2.1.epochtime |      2         |
      | test    | 0.0.2   | created | 0.0.2.2.epochtime |      1         |
      | test2   | 0.0.2   | created | 0.0.2.1.epochtime |      3         |
 
    When I update a <service>
    Then I should be notified with a change "<change>" and <change_version> should increment
    And update will happen to all services name <service>
    And 
    Examples:
     | service | change  | change_version |
     | test2   | changed |      4         |



  Scenario Outline: updating a service with service name and version:
    When I update a <service> and <version>
    Then I should be notified with a change "<change>" for all the 
    Examples:
      | change  |
      | changed |

      | service | version | change  | uniqueID          |  change_version |
      | test    | 0.0.1   | created | 0.0.1.1.epochtime |    2
      | test    | 0.0.1   | created | 0.0.1.2.epochtime |
      
      
   Scenario Outline: updating a service with service name and version and unique_ID
