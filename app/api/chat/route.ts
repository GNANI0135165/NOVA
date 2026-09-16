import { NextResponse } from "next/server";

const GEMINI_MODEL = "gemini-3.7-flash";

type ChatMessage = {
  role: "user" | "model";
  text: string;
};

export async function POST(request: Request) {
  try {
    const apiKey = process.env.GEMINI_API_KEY;

    if (!apiKey) {
      return NextResponse.json(
        {
          error: "GEMINI_API_KEY is not configured on the server.",
        },
        { status: 500 }
      );
    }

    const body = await request.json();

    const message = body?.message;
    const history: ChatMessage[] = Array.isArray(body?.history)
      ? body.history
      : [];

    if (typeof message !== "string" || message.trim().length === 0) {
      return NextResponse.json(
        {
          error: "A non-empty 'message' is required.",
        },
        { status: 400 }
      );
    }

    const contents = [
      ...history
        .filter(
          (item) =>
            (item.role === "user" || item.role === "model") &&
            typeof item.text === "string"
        )
        .map((item) => ({
          role: item.role,
          parts: [{ text: item.text }],
        })),

      {
        role: "user",
        parts: [{ text: message.trim() }],
      },
    ];

    const response = await fetch(
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
                text: `
You are NOVA, a highly capable AI assistant.

Be helpful, intelligent, concise, and natural.
Address the user respectfully.
Do not claim to have performed actions that you cannot actually perform.
When explaining technical topics, make the explanation clear and practical.
                `.trim(),
              },
            ],
          },

          contents,

          generationConfig: {
            temperature: 0.7,
            maxOutputTokens: 2048,
          },
        }),
      }
    );

    const data = await response.json();

    if (!response.ok) {
      console.error("Gemini API error:", data);

      return NextResponse.json(
        {
          error: "Gemini API request failed.",
          details: data?.error?.message ?? "Unknown Gemini API error",
        },
        { status: response.status }
      );
    }

    const text =
      data?.candidates?.[0]?.content?.parts
        ?.map((part: { text?: string }) => part.text ?? "")
        .join("") ?? "";

    if (!text) {
      return NextResponse.json(
        {
          error: "Gemini returned an empty response.",
        },
        { status: 502 }
      );
    }

    return NextResponse.json({
      success: true,
      response: text,
      model: GEMINI_MODEL,
    });
  } catch (error) {
    console.error("NOVA API error:", error);

    return NextResponse.json(
      {
        error: "Internal server error.",
      },
      { status: 500 }
    );
  }
}