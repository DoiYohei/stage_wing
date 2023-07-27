import axios from "@/plugins/axios";
import { getEvent, postEvent } from "@/utils/events";

jest.mock("@/plugins/axios");

describe("getEvent", () => {
  it("returns array of unregistered_performers", async () => {
    const event = {
      id: 1,
      unregistered_performers: "band1*/band2*/band3",
    };
    axios.get.mockResolvedValue({ data: event });
    const res = await getEvent(1);
    expect(res.unregistered_performers).toEqual(["band1", "band2", "band3"]);
  });
});

describe("postEvent", () => {
  it("posts string of joined unregistered_performers with */", async () => {
    const event = { name: "event" };
    const lineup = {
      newNoIdLineup: ["band1", "band2", "band3"],
    };
    const flyer = "flyer";
    postEvent(event, lineup, flyer);
    expect(axios.post).toHaveBeenCalledTimes(1);
    expect(axios.post.mock.calls[0][1].get("event[unregistered_performers]")).toBe("band1*/band2*/band3");
  });
});
