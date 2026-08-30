extends Node

const MOM_MINIMAP = [
	"Hey sweetheart! Just making sure you settled in okay. Remember, you can use the minimap to get around—just click on any building to head straight there. Oh, and don't forget to sleep in your bed every night to start a fresh day!",
	"I've also made some handy infocards for you so you don't get lost, just click the info icon on the side! And oh, have you heard about the amazing FARMBOT 9000? Just deposit 10,000 coins in the bank to get it! You do know how to use your phone, right?"
]
const MOM_FARM = ["You're actually commited to farming? That's cute. By the way, use keys 1 through 4 or click to switch your tools. Press I for your inventory, and if you want to use the barn for storage, just stand right next to it with your inventory open.", "Also, just a quick tip so you don’t get lost: you actually have to put seeds into your tool slot to plant them. And they won't grow an inch unless you water them every day, alright?"]
const MOM_SELL_SHOP = "Oh, you're heading to the market to sell your harvest? Just remember to drag items right out of your inventory to sell them for whatever price is advertised on the board. And hey, if you genuinely feel like a merchant is ripping you off hard, call the police—they'll investigate and get the crook arrested by the next day."
const MOM_SEED_SHOP = "Buying seeds can be tricky around here. Make sure to look closely into the reference book on the counter so you don't get swindled. And keep in mind, they only restock their seed stock tomorrow!"

const MOM_ASK_MONEY = "Oh darling, things are just so tight this week. Could you spot me 500 coins? I promise I'll pay you back the second my pension clears."
const MOM_MONEY_SENT = "Oh, thank you so much! ... Wait, my card just got declined at the grocery store, so I had to spend that on groceries instead. Sorry sweetheart, mommy loves you!"
const MOM_MONEY_DECLINED = "Oh... I see. Well, I suppose a mother's financial ruin is of little concern when there are crops to water. Forget I asked, darling. I'll just figure it out on my own... again. Bye."

const SHOPKEEPER_GENERIC = "Look, prices fluctuate based on 'market conditions.' What do you want, a receipt? We don't do refunds here, buddy. Inspect what you buy!"
const SHOPKEEPER_REPLACED_SCAMMER = "Hey there! Management just shifted me over here to take over the counter. The last guy cleared out his desk and left in a hurry—something about 'urgent personal business,' I think? Anyway, fresh inventory is on the shelves, same rules apply."
const SHOPKEEPER_REPLACED_INNOCENT = "Morning! The corporate transferred me here from the district branch. The previous owner got reassigned across the valley yesterday. I'm just settling in, so bear with me while I get the register sorted out. Let me know if you need anything."

const CALL_POLICE_NO_TARGET = "Police Dispatch. You want to report... no one? You can't call the police without a specific merchant to investigate! Call back when you're actually at a shop."
const POLICE_REPORT_ONLY_INNOCENT = "We checked out the merchants you flagged yesterday. Turns out you reported honest, law-abiding business owners who haven't broken a single ordinance. You're wasting our time, and your credibility in this town is taking a hit."
const POLICE_REPORT_ONLY_SCAMMERS = "Impressive work on yesterday's reports. Every single merchant you flagged turned out to be running illegal price hikes and counterfeit schemes. We hauled them in. The market is a little safer thanks to your sharp eye."
const POLICE_REPORT_MIXED = "Your reports yesterday were a mixed bag. You successfully pinned a couple of actual scammers, but you also dragged honest, innocent shopkeepers into our station for nothing. We appreciate the good tips, but you need to check your facts before dialing us."

const POLICE_TRUST_NEGATIVE = "Look at your record with us—you're deeply in the red. Because of this stunt, you've officially triggered a fine for public nuisance. And remember: If you keep messing around we will have to locked you up."
const POLICE_TRUST_ZERO = "Your file is sitting right on the edge of trouble. You've got zero margin for error left with this department. Straighten out your act, and make sure your next call is actually backed by proof."
const POLICE_TRUST_LOW = "We'll log the information for now, but your standing with us is still shaky. Keep your head down, do your job, and don't waste our time unless you're completely sure."
const POLICE_TRUST_MODERATE = "Given your solid track record with us so far, we're willing to give you the benefit of the doubt on this one. Keep up the vigilance and maintain that standing."
const POLICE_TRUST_HIGH = "As one of our most trusted informants, we always take your word seriously. Your standing with the department is spotless—keep helping us keep this town clean, and we'll always have your back."

const BANK_DEPOSIT = "Ah, right on schedule! Another fine deposit toward your ultimate loyalty tier. Your balance is looking healthier every day. Just keep saving up to reach that milestone for the grand farming gift!"
const BANK_ENDING = "Thank you for your final deposit! Your loyalty tier has officially been processed... Wait, what's that sound? Ah, security! Grab the cash bags and start the getaway vehicle, boss! Thanks for funding our early retirement, farmer. Trust no one."

const CALL_MOM_BUSY = "[You dial your mother’s number, but a sharp, rhythmic busy tone drones in your ear. The line is constantly engaged—she’s probably talking the ear off someone else.]"
const CALL_POLICE = "Dispatch, this is the farm up on the ridge. I’d like to file an official report on a merchant operating in the market. Their ledger and pricing don't add up, and I suspect foul play. Please send an officer to check them out."
