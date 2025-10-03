-- Neo4j Graph Database Exercise - Solution
-- Note: This is a Neo4j exercise, so solutions use Cypher query syntax

-- 1. Graph Schema Design - Create constraints and indexes
CREATE INDEX FOR (u:User) ON (u.id)
CREATE INDEX FOR (c:Company) ON (c.id)
CREATE INDEX FOR (s:Skill) ON (s.id)
CREATE INDEX FOR (co:Content) ON (co.id)

-- 2. Data Population - Create sample nodes and relationships
CREATE (u1:User {id: 1, name: "Alice", email: "alice@example.com", joined: date("2023-01-15")})
CREATE (u2:User {id: 2, name: "Bob", email: "bob@example.com", joined: date("2023-02-20")})
CREATE (u3:User {id: 3, name: "Charlie", email: "charlie@example.com", joined: date("2023-03-10")})
CREATE (u4:User {id: 4, name: "Diana", email: "diana@example.com", joined: date("2023-04-05")})

CREATE (c1:Company {id: 1, name: "TechCorp", industry: "Technology", location: "San Francisco"})
CREATE (c2:Company {id: 2, name: "DataSystems", industry: "Analytics", location: "New York"})
CREATE (c3:Company {id: 3, name: "AIInnovate", industry: "Artificial Intelligence", location: "Boston"})

CREATE (s1:Skill {id: 1, name: "SQL", category: "Database"})
CREATE (s2:Skill {id: 2, name: "Python", category: "Programming"})
CREATE (s3:Skill {id: 3, name: "Machine Learning", category: "AI"})
CREATE (s4:Skill {id: 4, name: "Networking", category: "Professional"})
CREATE (s5:Skill {id: 5, name: "Leadership", category: "Management"})

CREATE (co1:Content {id: 1, title: "SQL Best Practices", type: "Article", date: date("2024-01-10")})
CREATE (co2:Content {id: 2, title: "Python for Data Science", type: "Article", date: date("2024-01-12")})

-- Create relationships
CREATE (u1)-[:WORKS_AT {since: date("2022-06-01")}]->(c1)
CREATE (u2)-[:WORKS_AT {since: date("2023-01-15")}]->(c1)
CREATE (u3)-[:WORKS_AT {since: date("2023-08-20")}]->(c2)
CREATE (u4)-[:WORKS_AT {since: date("2023-11-05")}]->(c3)

CREATE (u1)-[:KNOWS {since: date("2023-02-01")}]->(u2)
CREATE (u2)-[:KNOWS {since: date("2023-02-15")}]->(u3)
CREATE (u1)-[:KNOWS {since: date("2023-03-01")}]->(u4)
CREATE (u3)-[:KNOWS {since: date("2023-05-10")}]->(u4)

CREATE (u1)-[:SKILLED_IN {endorsements: 5}]->(s1)
CREATE (u1)-[:SKILLED_IN {endorsements: 3}]->(s2)
CREATE (u2)-[:SKILLED_IN {endorsements: 7}]->(s1)
CREATE (u2)-[:SKILLED_IN {endorsements: 4}]->(s3)
CREATE (u3)-[:SKILLED_IN {endorsements: 6}]->(s2)
CREATE (u3)-[:SKILLED_IN {endorsements: 8}]->(s3)
CREATE (u4)-[:SKILLED_IN {endorsements: 4}]->(s4)
CREATE (u4)-[:SKILLED_IN {endorsements: 9}]->(s5)

CREATE (u1)-[:CREATED]->(co1)
CREATE (u3)-[:CREATED]->(co2)

CREATE (u2)-[:LIKES {date: date("2024-01-11")}]->(co1)
CREATE (u3)-[:LIKES {date: date("2024-01-13")}]->(co2)
CREATE (u4)-[:LIKES {date: date("2024-01-14")}]->(co1)

-- 3. Query Implementation

-- Find mutual connections
MATCH (u1:User {name: "Alice"})-[:KNOWS]-(mutual:User)-[:KNOWS]-(u2:User {name: "Bob"})
WHERE u1 <> u2
RETURN mutual.name AS mutualConnection

-- Discover skill clusters and expertise areas
MATCH (u:User)-[:SKILLED_IN]->(s:Skill)
WHERE s.name IN ["SQL", "Python"]
RETURN u.name, collect(s.name) AS skills

-- Calculate influence scores (based on connections)
MATCH (u:User)-[:KNOWS]-(connected:User)
RETURN u.name, count(connected) AS influence_score
ORDER BY influence_score DESC

-- Generate content recommendations based on connection's likes
MATCH (u:User {name: "Alice"})-[:KNOWS]-(friend:User)-[:LIKES]->(content:Content)<-[:LIKES]-(otherUser:User)
WHERE NOT (u)-[:LIKES]->(content)
RETURN content.title, count(otherUser) AS recommendation_score
ORDER BY recommendation_score DESC

-- 4. Advanced Analytics

-- Find all connections up to 3 degrees away (friends of friends of friends)
MATCH (u:User {name: "Alice"})-[:KNOWS*1..3]-(connections:User)
WHERE u <> connections
RETURN connections.name, length(rels) AS degree_of_separation

-- Find users with common skills
MATCH (u1:User {name: "Alice"})-[:SKILLED_IN]->(s:Skill)<-[:SKILLED_IN]-(u2:User)
WHERE u1 <> u2
RETURN u2.name, collect(s.name) AS common_skills

-- Advanced Challenges

-- 1. Recommendation Engine: Suggest new connections based on mutual interests
MATCH (u:User {name: "Alice"})-[:SKILLED_IN]->(s:Skill)<-[:SKILLED_IN]-(candidate:User)-[:KNOWS]-(connection:User)
WHERE NOT (u)-[:KNOWS]-(candidate)
RETURN candidate.name, count(s) AS common_skills, count(connection) AS mutual_connections
ORDER BY common_skills DESC, mutual_connections DESC

-- 2. Content Viral Analysis: Track how content spreads through the network
MATCH path = (creator:User)-[:CREATED]->(content:Content)<-[:LIKES]-(liker:User)-[:KNOWS*1..3]-(influencer:User)
WHERE content.title = "SQL Best Practices"
RETURN path

-- 3. Fraud Detection: Identify suspicious connection patterns
MATCH (u1:User)-[:KNOWS]-(u2:User)-[:KNOWS]-(u3:User)-[:KNOWS]-(u1)
WHERE u1 <> u2 AND u2 <> u3 AND u1 <> u3
OPTIONAL MATCH (u1)-[:SKILLED_IN]->(s1:Skill)<-[:SKILLED_IN]-(u2)-[:SKILLED_IN]->(s2:Skill)<-[:SKILLED_IN]-(u3)
WITH u1, u2, u3, (CASE WHEN s1 IS NOT NULL OR s2 IS NOT NULL THEN 1 ELSE 0 END) AS has_common_skills
WHERE has_common_skills < 2  -- Users with no common skills might be suspicious
RETURN u1.name, u2.name, u3.name
</content>