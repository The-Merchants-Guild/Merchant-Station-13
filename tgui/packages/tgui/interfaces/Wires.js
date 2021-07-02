import { useBackend, useLocalState } from '../backend';
import { Box, Icon, Section, NoticeBox } from '../components';
import { Window } from '../layouts';

export const Wires = (props, context) => {
  const { act, data } = useBackend(context);
  const { proper_name } = data;
  const wires = data.wires || [];
  const statuses = data.status || [];
  const [attach, setAttach] = useLocalState(context, "attach", 1);
  const [connecting, setConnecting] = useLocalState(context, "connecting", "");
  return (
    <Window
      width={350}
      height={150
        + (wires.length * 30) + 30
        + (!!proper_name && 30)}>
      <Window.Content>
        {(!!proper_name && (
          <NoticeBox textAlign="center">
            {proper_name} Wire Configuration
          </NoticeBox>
        ))}
        <Section height={60 + wires.length * 25 - 7 + "px"}>
          <svg width="100%" height="100%" style={{
            "position": "absolute",
          }}>
            <rect
              width="62"
              height="16"
              x="3"
              y="-3"
              fill="blue"
              onClick={() => (setAttach(!attach))}
            />
            <text x="5" y="10" fill="white" font-size="14px" style={{ "pointer-events": "none" }}>
              {attach ? "Attach" : "Connect"}
            </text>
            <text x="70" y="10" fill="white" font-size="14px">
              Cut
            </text>
            <text x="114" y="10" fill="white" font-size="14px">
              Pulse
            </text>
            {wires.map((val, index) => {
              let y = 30 + index * 25;
              let end = "";
              if (val.cut) {
                end = "25 0 M 124 "+ y +" l -25 0";
              } else {
                end = "82 0";
              }
              let path = "M 42 " + y + " l " + end;
              { return (
                <g key={index}>
                  {!!val.attached && (
                    <text x="5" y={y + 5} fill="white" stroke="#444" stroke-width="0.5" font-size="16px">
                      A
                    </text>)}
                  <rect
                    width="20"
                    height="20"
                    x="23"
                    y={y - 10}
                    stroke={val.color}
                    stroke-width="2"
                    fill={connecting === val.color ? connecting : "gold"}
                    onClick={() => { attach ? act('attach', {
                      wire: val.color,
                    }) : setConnecting(val.color); }}
                  />
                  <rect
                    width="20"
                    height="20"
                    x="123"
                    y={y - 10}
                    stroke={val.color}
                    stroke-width="2"
                    fill="gold"
                    onClick={() => {
                      if (connecting) {
                        if (connecting !== val.color) {
                          act('connect', {
                            wire: connecting,
                            dest: val.color,
                          });
                        }
                        setConnecting("");
                      } else {
                        act('pulse', { wire: val.color });
                      }
                    }}
                  />
                  {!!val.connections && val.connections.map((v, i) => {
                    let a = 0;
                    { wires.some((w, wI) => {
                      if (w.color === v) {
                        a = wI;
                        return;
                      }
                    }); }
                    let p = "M 42 " + y + " L 124 " + (30 + a * 25);
                    return (
                      <g key={index + "-" + i} onClick={() => act('cut_connection', {
                        wire: val.color,
                        dest: v,
                      })}>
                        <path d={p} stroke="#666600" stroke-width="8" />
                        <path d={p} stroke="#E8E800" stroke-width="6" />
                      </g>
                    );
                  })}
                  <g onClick={() => act('cut', {
                    wire: val.color,
                  })}>
                    <path d={path} stroke="#666600" stroke-width="8" />
                    <path d={path} stroke="#E8E800" stroke-width="6" />
                  </g>
                  <text x="150" y={y + 5} fill={val.color} stroke="#444" stroke-width="0.5" font-size="16px">
                    {val.wire ? val.wire
                      : val.color.charAt(0).toUpperCase()+val.color.slice(1)}
                  </text>
                </g>
              ); }
            })};
            {!!statuses.length && ("a")}
          </svg>
        </Section>
        {!!statuses.length && (
          <Section>
            {statuses.map(status => (
              <Box key={status}>
                {status}
              </Box>
            ))}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
