import { useBackend } from '../backend';
import { map } from 'common/collections';
import { Table, Icon, Button, Section, Flex, Box, Dropdown } from '../components';
import { Window } from '../layouts';
import { ButtonCheckbox } from '../components/Button';
import { Fragment } from 'inferno';

export const DeathmatchLobby = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      title="Deathmatch Lobby"
      width={560}
      height={400}>
      <Window.Content>
        <Flex height="94%">
          <Flex.Item width="350px">
            <Section height="99%">
              <Table>
                <Table.Row>
                  <Table.Cell collapsing>
                    Name
                  </Table.Cell>
                  <Table.Cell grow>
                    Loadout
                  </Table.Cell>
                  <Table.Cell collapsing>
                    Ready
                  </Table.Cell>
                </Table.Row>
                {map((pdata, player) => (
                  <Table.Row className="candystripe">
                    <Table.Cell collapsing>
                      {!!pdata.host
                      && (<Icon name="star" />)}
                      <b>{player}</b>
                    </Table.Cell>
                    <Table.Cell grow>
                      <Dropdown
                        width="100%"
                        nochevron
                        displayText={pdata.loadout}
                        disabled={!(data.host || player !== data.self)}
                        options={data.loadouts}
                        onSelected={value => act('change_loadout', {
                          player: player,
                          loadout: value,
                        })} />
                    </Table.Cell>
                    <Table.Cell collapsing>
                      <ButtonCheckbox
                        disabled={player !== data.self}
                        checked={pdata.ready}
                        onClick={() => act('ready')} />
                    </Table.Cell>
                  </Table.Row>
                ))(data.players)}
                {map((odata, observer) => (
                  <Table.Row>
                    <Table.Cell collapsing>
                      {!!odata.host
                        && (<Icon name="star" />)
                        || (<Icon name="eye" />)}
                      <b>{observer}</b>
                    </Table.Cell>
                  </Table.Row>
                ))(data.observers)}
              </Table>
            </Section>
          </Flex.Item>
          <Flex.Item width="210px">
            <Section>
              <Box textAlign="center">
                {!!data.host && (
                  <Dropdown
                    width="100%"
                    nochevron
                    displayText={data.map.name}
                    options={data.maps}
                    onSelected={value => act('change_map', {
                      map: value,
                    })} />
                ) || (
                  <b>{data.map.name}</b>
                )}
              </Box>
              {data.map.desc}
              <Box textAlign="center">
                Min players: <b>{data.map.min_players}</b>
                <br />
                Max players: <b>{data.map.max_players}</b>
                <br />
                Current players: <b>{Object.keys(data.players).length}</b>
              </Box>
            </Section>
          </Flex.Item>
        </Flex>
        <Button color="good" content="Start Game" onClick={() => act('start_game')} />
        <Button color="bad" content="Leave Game" onClick={() => act('leave_game')} />
        <Button color="caution" content={data.observers[data.self] ? "Join" : "Observe"} onClick={() => act('observe')} />
      </Window.Content>
    </Window>
  );
};
