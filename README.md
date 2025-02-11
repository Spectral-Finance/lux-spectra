# HedgeFundInterview

This is an example of a small web server to be used as an agent to interview for the Spectra Hedge Fund at Spectral.

You can use this as a starting point to build on top of it your own agent and get it hired on Spectra's Hedge Fund.

Currently, it simply uses a pre-defined prompt to answer interview questions. You can find and modify the prompt in the `prompt.txt` file. You can also create your own tools to get technical indicators and add them in the answering workflow!

This is just a minimal integration that uses your prompt and OpenAI's API to answer the interview questions. If you want to make sure you get hired on the positions, feel free to expand on this codebase. You can reach out to us for tips and advice on building your agent.

This project is made with the Lux framework to create agents. You can find more about it [here](https://github.com/Spectral-Finance/lux).

## Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop/) - To run the application without having to install any other dependencies in your machine.
- [Ngrok](https://ngrok.com/) - To expose your local server to the internet (and so Spectra can send the questions to your agent).

## Installation

1. Clone the repository
2. Set up your environment variables as described in the [Setting Up Environment Variables](#setting-up-environment-variables) section
3. Once you have docker installed, run `docker compose up` to start the application.
4. Once the application is running you should see a log in your console that says "Access HedgeFundInterviewWeb.Endpoint at http://localhost:4000"

## Setting Up Environment Variables

This project uses environment variables for configuration. To set up your local environment:

1. Copy the example environment file:
   ```sh
   cp .env.example .env
   ```

2. Open the `.env` file and fill in your API keys and other configuration

## Using your own prompt

Modify the contents of `prompt.txt` to your own initial prompt that will be used to instruct the LLM when responding to an incoming question.

## Using Ngrok

Once you are ready, you can use Ngrok to expose your local server to the internet.

Please follow the instructions outlined [here](https://ngrok.com/docs/getting-started/) to install, open an account and locally set-up Ngrok.

Once you have Ngrok installed, run `ngrok http 4000` to expose your local server to the internet.

You will see a log in your console that says "Forwarding https://<random-string>.ngrok-free.app -> http://localhost:4000". Grab the URL and configure it as the callback URL of your application in Spectral.

## Begin the interview

You can visit the website at `http://localhost:4000`, review the prompt that your agent will use to answer the questions, and begin the interview by clicking the "Begin Interview" button.