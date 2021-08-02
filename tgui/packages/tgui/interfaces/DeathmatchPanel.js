import { useBackend } from '../backend';
import { Table, Button, Section, Flex } from '../components';
import { Window } from '../layouts';

export const DeathmatchPanel = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      title="Deathmatch Lobbies"
      width={360}
      height={600}>
      <Window.Content>
        <Section height="530px">
          <Table>
            <Table.Row>
              <Table.Cell bold>
                Host
              </Table.Cell>
              <Table.Cell bold>
                Map
              </Table.Cell>
              <Table.Cell bold>
                Players
              </Table.Cell>
            </Table.Row>
            {data.lobbies.map(lobby => (
              <Table.Row key={lobby.name}>
                <Table.Cell>
                  {lobby.name}
                </Table.Cell>
                <Table.Cell>
                  {lobby.map}
                </Table.Cell>
                <Table.Cell>
                  {lobby.players}/{lobby.max_players}
                </Table.Cell>
                <Table.Cell>
                  {!lobby.playing && (
                    <Button disabled={data.hosting && data.playing !== lobby.name} color="good" content="Join" onClick={() => act('join', { "id": lobby.name })} />
                  ) || (
                    <Button disabled={data.hosting} color="good" content="Spectate" onClick={() => act('spectate', { "id": lobby.name })} />
                  )}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
        <Flex>
          <Flex.Item>
            <Button disabled={data.hosting} color="good" content="Create Lobby" onClick={() => act('host')} />
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
