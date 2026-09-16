import { NextResponse } from "next/server";

const GEMINI_MODEL = "gemini-3.7-flash";

type ChatMessage = {
  role: "user" | "model";
  text: string;
};

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};

export async function OPTIONS() {
  return new NextResponse(null, {
    status: 204,
    headers: corsHeaders,
  });
}

export async function POST(request: Request) {
  try {
    const apiKey = process.env.GEMINI_API_KEY;

    if (!apiKey) {
      return NextResponse.json(
        {
          error: "GEMINI_API_KEY is not configured on the server.",
        },
        {
          status: 500,
          headers: corsHeaders,
        },
      );
    }

    const body = await request.json();

    const message =
        typeof body?.message === "string"
            ? body.message.trim()
            : "";

    if (!message) {
      return NextResponse.json(
        {
          error: "Message is required.",
        },
        {
          status: 400,
          headers: corsHeaders,
        },
      );
    }

    const history: ChatMessage[] = Array.isArray(body?.history)
        ? body.history
            .filter(
              (item: any) =>
                  (item?.role === "user" || item?.role === "model") &&
                  typeof item?.text === "string",
            )
            .map((item: any) => ({
              role: item.role,
              text: item.text,
            }))
        : [];

    const contents = [
      ...history.map((item) => ({
        role: item.role,
        parts: [{ text: item.text }],
      })),

      {
        role: "user",
        parts: [{ text: message }],
      },
    ];

    const geminiResponse = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "x-goog-api-key": apiKey,
        },
        body: JSON.stringify({
          systemInstruction: {
            parts: [
              {
                text: `You are NOVA, a highly capable AI assistant.

Your personality:
- Intelligent
- Calm
- Helpful
- Professional
- Slightly futuristic
- Concise but useful

Address the user as Boss when appropriate.

Answer questions naturally and accurately.`,
              },
            ],
          },
          contents,
        }),
      },
    );

    const geminiData = await geminiResponse.json();

    if (!geminiResponse.ok) {
      console.error("Gemini API error:", geminiData);

      return NextResponse.json(
        {
          error:
            geminiData?.error?.message ||
            "Gemini API request failed.",
        },
        {
          status: geminiResponse.status,
          headers: corsHeaders,
        },
      );
    }

    const responseText =
      geminiData?.candidates?.[0]?.content?.parts
        ?.map((part: any) => part?.text || "")
        .join("")
        .trim();

    if (!responseText) {
      return NextResponse.json(
        {
          error: "Gemini returned an empty response.",
        },
        {
          status: 500,
          headers: corsHeaders,
        },
      );
    }

    return NextResponse.json(
      {
        success: true,
        response: responseText,
        model: GEMINI_MODEL,
      },
      {
        status: 200,
        headers: corsHeaders,
      },
    );
  } catch (error) {
    console.error("NOVA API error:", error);

    return NextResponse.json(
      {
        error: "Internal server error.",
      },
      {
        status: 500,
        headers: corsHeaders,
      },
    );
  }
}