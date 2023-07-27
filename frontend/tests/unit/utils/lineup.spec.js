import axios from "@/plugins/axios";
import { setLineupForShow, patchLineup, filterLineupForUpdate } from "@/utils/lineup";

jest.mock("@/plugins/axios");
jest.mock("@/utils/routers");

describe("setLineupForShow", () => {
  it("returns lineup for show", () => {
    const event = { performers: [{ id: 1, name: "band1" }, { id: 2, name: "band2" }] , unregistered_performers: ["band3", "band4"] };
    const lineup = setLineupForShow(event);
    expect(lineup).toEqual([{ text: "band1", to: "/bands/1" }, { text: "band2", to: "/bands/2" }, { text: "band3" }, { text: "band4" }]);
  });
});

describe("patchLineup", () => {
  it("calls postLineup twice and deleteLineup once", async () => {
    const event = { id: 1, performers: [{ id: 1 }, { id: 2 }, { id: 3 }] };
    const lineup = { newLineup: [{ id: 1 }, { id: 2 }, { id: 4 }, { id: 5 }], newNoIdLineup: [] };
    await patchLineup(event, lineup);
    expect(axios.post).toHaveBeenCalledTimes(2);
    expect(axios.post.mock.calls[0][1].get("lineup[performer_id]")).toBe("4");
    expect(axios.post.mock.calls[1][1].get("lineup[performer_id]")).toBe("5");
    expect(axios.delete).toHaveBeenCalledTimes(1);
    expect(axios.delete.mock.calls[0][1].data.get("lineup[performer_id]")).toBe("3");
  });
});

describe("filterLineupForUpdate", () => {
  it("returns lineup for update", () => {
    const lineup = [{ id: 1 }, { id: 2 }, { id: 3 }];
    const otherLineup = [{ id: 3 }, { id: 4 }, { id: 5 }];
    const lineupForUpdate = filterLineupForUpdate(lineup, otherLineup);
    expect(lineupForUpdate).toEqual([{ id: 1 }, { id: 2 }]);
  });
});
