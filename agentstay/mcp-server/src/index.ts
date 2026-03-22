#!/usr/bin/env node
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  ErrorCode,
  McpError,
} from "@modelcontextprotocol/sdk/types.js";
import { tools, handleTool } from "./tools.js";

const server = new Server(
  {
    name: "agentstay",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

server.setRequestHandler(ListToolsRequestSchema, async () => {
  console.error("[AgentStay MCP] Listing tools");
  return { tools };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;
  console.error(`[AgentStay MCP] Tool call: ${name}`);

  try {
    const result = await handleTool(name, args);
    return {
      content: [
        {
          type: "text",
          text: result,
        },
      ],
    };
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    console.error(`[AgentStay MCP] Tool error: ${message}`);
    throw new McpError(ErrorCode.InternalError, message);
  }
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("[AgentStay MCP] Server running on stdio");
  console.error(`[AgentStay MCP] API URL: ${process.env.API_BASE_URL || "http://localhost:8000"}`);
}

main().catch((err) => {
  console.error("[AgentStay MCP] Fatal error:", err);
  process.exit(1);
});
