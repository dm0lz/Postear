Feature: User Postea in twitter

	As a fetcher user 
	I want to be able to post to twitter
	And to select from which of my social network accounts i want to post
	And to be able to post from only one specific account
	So that i can manage my social marketing campaigns

	Scenario: A User posts 
		Given i am "olivier"
		When i hit the postear page
		Then i should see my differents accounts
		And i should be able to select the ones i want to post to
